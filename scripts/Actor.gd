extends Node2D

export var is_hero : bool = false

onready var sprite = $Character

func play_anim(anim, directional = true):
	if directional:
		anim = anim + last_direction
	if sprite.animation != anim:
		sprite.play(anim)

enum States {
	idle,
	walk_grid,
	walk_grid_centered,
	##
	attack
}
var state = States.idle

# Attack logic
var selected_weapon = 1
func do_attack():
	if state == States.idle:
		state = States.attack
		var weapon_data = Game.CONST_DATA.characters[selected_weapon] 
		Game.play_sound(weapon_data.weapon_refid)

# HP
const MAX_HEALTH = 0x300
var health = MAX_HEALTH

# tile vars
var USE_GRID = true
onready var tile_current = Game.to_tile(position)
onready var tile_fractional = Game.to_tile(position, false)
onready var tile_target = Vector2(floor(tile_current.x), floor(tile_current.y))
func teleport(tile):
	tile_current = tile
	tile_fractional = tile
	tile_target = tile
	position = Game.to_vector(tile)

var last_bumped_tile = null # spam prevention
func bump_into(bumped_tile):
	if last_bumped_tile != bumped_tile:
		last_bumped_tile = bumped_tile
		return Game.force_script_update()
	return false

var linked_object = null
var last_attempted_input = Vector2()
var force_release_input = 0.0
func link_object(obj):
	if linked_object != null:
		linked_object.linked_actor = null
		linked_object.reparent(Game.WALL_TILES)
		linked_object.recenter()
	if obj != null:
		Game.play_sound(1)
		obj.linked_actor = self
		obj.reparent(self)
	linked_object = obj
func attempt_moving_into(attempted_input):
	var target_is_obstructed = Game.is_tile_obstructed(tile_current + attempted_input)
	var is_diagonal = attempted_input.x != 0 && attempted_input.y != 0
	
	# no general obstructions
	if !target_is_obstructed:
		if !is_diagonal && Input.is_action_pressed("drag"):
			var object = Game.get_object_at(tile_current - attempted_input)
			if object != null && object.is_in_group("draggable"):
				link_object(object)
		return attempted_input
	
	# if bumping triggers an action, don't move
	if bump_into(tile_current + attempted_input):
		force_release_input = 0.25
		return Vector2()
	
	var x_only = attempted_input * Vector2(1,0)
	var y_only = attempted_input * Vector2(0,1)
	var x_is_obstructed = Game.is_tile_obstructed(tile_current + x_only)
	var y_is_obstructed = Game.is_tile_obstructed(tile_current + y_only)
	
	# diagonal movement
	if is_diagonal:
		if x_is_obstructed && y_is_obstructed:
			return Vector2()
		elif y_is_obstructed:
			return x_only
		elif x_is_obstructed:
			return y_only
	elif Input.is_action_pressed("drag"):
		var object = Game.get_object_at(tile_current + attempted_input)
		if object != null:
			if !Game.is_tile_obstructed(tile_current + 2 * attempted_input):
				link_object(object)
				return attempted_input
	
	# normal obstruction
	return Vector2()

var last_direction : String = "_S"
func do_movement(delta):
	# update current tile
	tile_fractional = Game.to_tile(position, false)
	tile_current = Game.round_vector(tile_fractional)
	
	match state:
		States.idle, States.walk_grid, States.walk_grid_centered:
			
			# update the input pause timer
			if force_release_input > 0:
				force_release_input -= delta
			
			# get movement INPUT VECTOR only when centered on the tile
			var moved_input = Vector2()
			var attempted_input = Vector2()
			if !Game.can_control_hero():
				last_bumped_tile = null
				last_attempted_input = Vector2()
			elif tile_fractional == tile_current:
				link_object(null)
				if Input.is_action_pressed("up"):
					attempted_input += Vector2(0,-1)
					last_direction = "_N"
				if Input.is_action_pressed("down"):
					attempted_input += Vector2(0,1)
					last_direction = "_S"
				if Input.is_action_pressed("left"):
					attempted_input += Vector2(-1,0)
					last_direction = "_W"
				if Input.is_action_pressed("right"):
					attempted_input += Vector2(1,0)
					last_direction = "_E"
				
				# if an input is attempted, follow up on it
				if attempted_input != Vector2():
					if force_release_input <= 0.0 || last_attempted_input != attempted_input: # if inputs are paused, skip.
						force_release_input = 0.0
						moved_input = attempt_moving_into(attempted_input)
					
					# correct direction depending on actual movement
					if moved_input.x == -1:
						last_direction = "_W"
					elif moved_input.x == 1:
						last_direction = "_E"
					elif moved_input.y == -1:
						last_direction = "_N"
					elif moved_input.y == 1:
						last_direction = "_S"
				else:
					# reset the "bump" spam prevention and input pausing if inputs are released
					last_bumped_tile = null
					force_release_input = 0.0
				
				# remember the input vector for next frame usage
				last_attempted_input = attempted_input
			
			# update target tile ONLY if there is an actual movement
			if moved_input != Vector2():
				tile_target = tile_current + moved_input

			# finalize movement -- move towards the target tile (clamped so it doesn't overshoot)
			var target_displacement = Game.to_vector(tile_target) - position
			var max_displacement = 200.0 * delta
			position += Vector2(
				clamp(target_displacement.x, -max_displacement, max_displacement),
				clamp(target_displacement.y, -max_displacement, max_displacement))
			
			# update states
			if tile_target == Game.to_tile(position, false):
				if target_displacement == Vector2():
					state = States.idle
				else:
					state = States.walk_grid_centered
			else:
				state = States.walk_grid

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_movement(delta)
	
	if Game.can_control_hero():
		if Input.is_action_pressed("attack"):
			do_attack()

	# sprite animations
	match state:
		States.idle:
			play_anim("idle")
		States.walk_grid, States.walk_grid_centered:
			play_anim("walk")
		States.attack:
			var weapon_data = Game.CONST_DATA.characters[selected_weapon]
			play_anim(weapon_data.name)
			get_node("Attack" + last_direction).play(weapon_data.name + last_direction)


# Called when the node enters the scene tree for the first time.
func _ready():
	if is_hero:
		Game.HERO_ACTOR = self
	$Attack_N.frames = Game.ATTACK_SPRITESHEET
	$Attack_S.frames = Game.ATTACK_SPRITESHEET
	$Attack_W.frames = Game.ATTACK_SPRITESHEET
	$Attack_E.frames = Game.ATTACK_SPRITESHEET
	position = Game.to_vector(tile_target)

func _on_Character_animation_finished():
	match state:
		States.attack:
			$Attack_N.play("default")
			$Attack_S.play("default")
			$Attack_W.play("default")
			$Attack_E.play("default")
			state = States.idle
