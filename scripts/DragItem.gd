extends TextureRect

var item_slot = null
var item_id = null
var dragging_onto = null

func is_hovering(control):
	if !visible:
		return false
	return get_global_rect().intersects(control.get_global_rect())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
