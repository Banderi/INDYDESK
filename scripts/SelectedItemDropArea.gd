extends ColorRect

onready var item_node = $InventoryItem

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Cursor.drag_texture.is_hovering(self):
		$ColorRect.show()
	else:
		$ColorRect.hide()
