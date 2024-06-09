extends Node2D

onready var attack_spritesheet = $Attack_E.frames
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
onready var tile_current = to_tile(position)
onready var tile_target = Vector2(floor(tile_current.x), floor(tile_current.y))
func to_tile(vector, rounded = true):
	var tile = (vector - Vector2(16,16)) / 32.0
	if rounded:
		tile.x = round(tile.x)
		tile.y = round(tile.y)
	return tile
func to_vector(tile):
	return (tile * 32.0) + Vector2(16,16)

func correct_unobstructed_movement(moved_input):
	var x_only = moved_input * Vector2(1,0)
	var y_only = moved_input * Vector2(0,1)
	var x_is_obstructed = Game.is_tile_obstructed(tile_current + x_only)
	var y_is_obstructed = Game.is_tile_obstructed(tile_current + y_only)
	
	if moved_input.x == 0:
		if y_is_obstructed:
			return Vector2()
	elif moved_input.y == 0:
		if x_is_obstructed:
			return Vector2()
	else:
		if x_is_obstructed && y_is_obstructed:
			return Vector2()
		elif y_is_obstructed:
			return x_only
		elif x_is_obstructed:
			return y_only
	
	if Game.is_tile_obstructed(tile_current + moved_input):
		return Vector2()
	return moved_input

var last_direction : String = "_S"
func do_movement(delta):
	# update current tile
	tile_current = to_tile(position)
	
	match state:
		States.idle, States.walk, States.walk_grid:
			
			# get movement INPUT VECTOR
			var moved_input = Vector2()
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
			moved_input = correct_unobstructed_movement(moved_input)
			
			# update target tile ONLY if there was a detected input
			if moved_input != Vector2():
				tile_target = tile_current + moved_input
	
			# finalize movement -- move towards the target tile (clamped so it doesn't overshoot)
			var target_displacement = to_vector(tile_target) - position
			var max_displacement = 200.0 * delta
			position += Vector2(
				clamp(target_displacement.x, -max_displacement, max_displacement),
				clamp(target_displacement.y, -max_displacement, max_displacement))
			
			# update states accordingly
			if target_displacement == Vector2():
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
	position = to_vector(tile_target)

func _on_Character_animation_finished():
	match state:
		States.attack:
			$Attack_N.play("default")
			$Attack_S.play("default")
			$Attack_W.play("default")
			$Attack_E.play("default")
			state = States.idle
