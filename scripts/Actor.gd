extends Node2D

export var is_hero : bool = false

onready var sprite = $Character

func play_anim(anim, directional = true):
	if directional:
		anim = anim + last_direction
	if sprite.animation != anim:
		sprite.play(anim)

var state = 0
enum States {
	idle,
	walk,
	walk_grid,
	##
	attack
}

var selected_weapon = "WhipWeapon"
func do_attack():
	if state == States.idle:
		state = States.attack

var USE_GRID = true
onready var tile_current = Game.to_tile(position)
onready var tile_fractional = Game.to_tile(position, false)
onready var tile_target = Vector2(floor(tile_current.x), floor(tile_current.y))

var linked_object = null
func link_object(obj):
	if linked_object != null:
		linked_object.linked_actor = null
		linked_object.reparent(Game.WALL_TILES)
		linked_object.recenter()
	if obj != null:
		obj.linked_actor = self
		obj.reparent(self)
	linked_object = obj
func attempt_moving_into(moved_input):
	var target_is_obstructed = Game.is_tile_obstructed(tile_current + moved_input)
	var is_diagonal = moved_input.x != 0 && moved_input.y != 0
	
	# no general obstructions
	if !target_is_obstructed:
		if !is_diagonal && Input.is_action_pressed("drag"):
			var object = Game.get_object_at(tile_current - moved_input)
			if object != null:
				link_object(object)
		return moved_input
	
	var x_only = moved_input * Vector2(1,0)
	var y_only = moved_input * Vector2(0,1)
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
		var object = Game.get_object_at(tile_current + moved_input)
		if object != null:
			if !Game.is_tile_obstructed(tile_current + 2 * moved_input):
				link_object(object)
				return moved_input
	
	# normal obstruction
	return Vector2()

var last_direction : String = "_S"
func do_movement(delta):
	# update current tile
	tile_fractional = Game.to_tile(position, false)
	tile_current = Game.round_vector(tile_fractional)
	
	match state:
		States.idle, States.walk, States.walk_grid:
			
			# get movement INPUT VECTOR only when centered on the tile
			var moved_input = Vector2()
			if tile_fractional == tile_current:
				link_object(null)
				if Input.is_action_pressed("up"):
					moved_input += Vector2(0,-1)
					last_direction = "_N"
				if Input.is_action_pressed("down"):
					moved_input += Vector2(0,1)
					last_direction = "_S"
				if Input.is_action_pressed("left"):
					moved_input += Vector2(-1,0)
					last_direction = "_W"
				if Input.is_action_pressed("right"):
					moved_input += Vector2(1,0)
					last_direction = "_E"
				
				# if an input is attempted, follow up on it
				if moved_input != Vector2():
					moved_input = attempt_moving_into(moved_input)
					
					# correct direction depending on actual movement
					if moved_input.x == -1:
						last_direction = "_W"
					elif moved_input.x == 1:
						last_direction = "_E"
					elif moved_input.y == -1:
						last_direction = "_N"
					elif moved_input.y == 1:
						last_direction = "_S"
			
			# update target tile ONLY if there is an actual movement
			if moved_input != Vector2():
				tile_target = tile_current + moved_input

			# finalize movement -- move towards the target tile (clamped so it doesn't overshoot)
			var target_displacement = Game.to_vector(tile_target) - position
			var max_displacement = 200.0 * delta
			position += Vector2(
				clamp(target_displacement.x, -max_displacement, max_displacement),
				clamp(target_displacement.y, -max_displacement, max_displacement))
			
			# update states accordingly
			if target_displacement == Vector2():
				if state == States.walk_grid:
					Game.do_triggers(tile_current)
				state = States.idle
			else:
				state = States.walk_grid
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_movement(delta)
	
	if Input.is_action_pressed("attack"):
		do_attack()

	# sprite animations
	match state:
		States.idle:
			play_anim("idle")
		States.walk, States.walk_grid:
			play_anim("walk")
		States.attack:
			play_anim(selected_weapon)
			get_node("Attack" + last_direction).play(selected_weapon + last_direction)


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
