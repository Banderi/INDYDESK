extends Sprite

var linked_zone_id = -1 # this is used for saving data and when unloading zones
var linked_actor = null
var tile_id = -1
var tile_flags = null

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("objects")
	add_to_group(str("zone_",linked_zone_id))

# Called every frame. 'delta' is the elapsed time since the previous frame.
var prev_tile = null
func reparent(new_parent):
	if linked_actor != null: # was PICKED UP by an actor!
		prev_tile = Game.to_tile(global_position)
	var prev_global_position = global_position
	get_parent().remove_child(self)
	new_parent.add_child(self)
	global_position = prev_global_position
func recenter():
	var tile = Game.to_tile(position)
	position = Game.to_vector(tile)
	
	# update zone data to reflect the new object position for zone reloading
	Game.set_tile_at(prev_tile, 1, -1, false, true)
	Game.set_tile_at(tile, 1, tile_id, false, true)
	
