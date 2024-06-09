extends Sprite

var linked_actor = null
var tile_id = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("objects")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func reparent(new_parent):
	var prev_global_position = global_position
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = prev_global_position
func recenter():
	var tile = Game.to_tile(position)
	position = Game.to_vector(tile)
	
