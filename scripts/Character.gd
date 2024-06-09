extends KinematicBody2D

onready var attack_spritesheet = $Attack_E.frames
onready var sprite = $Character

func play_anim(anim, _speed = 1.0):
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
	match state:
		States.attack:
			return
		_:
			if movement == Vector2():
				state = States.attack
				sprite.play(selected_weapon+direction)
				get_node("Attack"+direction).play(selected_weapon+direction)

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

var direction : String = "_S"
var movement = Vector2()
func do_movement(delta):
	
	tile_current = to_tile(position)
	
	match state:
		States.idle, States.walk, States.walk_grid:
			
			# get movement INPUT VECTOR
			var moved_input = Vector2()
			if Input.is_action_pressed("up"):
				moved_input += Vector2(0,-1)
				direction = "_N"
			if Input.is_action_pressed("down"):
				moved_input += Vector2(0,1)
				direction = "_S"
			if Input.is_action_pressed("left"):
				moved_input += Vector2(-1,0)
				direction = "_W"
			if Input.is_action_pressed("right"):
				moved_input += Vector2(1,0)
				direction = "_E"
			
			if moved_input != Vector2():
				tile_target = tile_current + moved_input
	
	
			var position_target = to_vector(tile_target)
			var position_excess = position_target - position
#			movement = Vector2(
#				sign(position_excess.x) * min(200.0 * delta, abs(position_excess.x)),
#				sign(position_excess.y) * min(200.0 * delta, abs(position_excess.y)))
			movement = Vector2(
				clamp(position_excess.x, -200.0 * delta, 200.0 * delta),
				clamp(position_excess.y, -200.0 * delta, 200.0 * delta))
			position += movement
#			if abs(position_excess.x) < abs(movement.x):
#				position.x = position_target.x
#			else:
#				position.x += movement.x
#
#			if abs(position_excess.y) < abs(movement.y):
#				position.y = position_target.y
#			else:
#				position.y += movement.y
			
			
			if position_excess == Vector2():
				position = position_target
				state = States.idle
				movement = Vector2()
			else:
				state = States.walk_grid
			
	# sprite animations
	match state:
		States.idle:
			play_anim(str("idle",direction))
		States.walk, States.walk_grid:
			play_anim(str("walk",direction))
	
	
	
	if Input.is_action_pressed("attack"):
		do_attack()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_movement(delta)

#func _input(_event):
#	if Input.is_action_pressed("attack"):
#		do_attack()

# Called when the node enters the scene tree for the first time.
func _ready():
	position = to_vector(tile_target)
	pass # Replace with function body.

func _on_Character_animation_finished():
	pass
	match state:
		States.attack: # attack
#			if Input.is_action_pressed("attack"):
#				do_attack()
#			else:
			$Attack_N.play("default")
			$Attack_S.play("default")
			$Attack_W.play("default")
			$Attack_E.play("default")
			state = States.idle
