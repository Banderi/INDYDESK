extends TextureButton

var tile_id = null setget set_item
func set_item(id):
	tile_id = id
	texture_normal = Game.get_sprite(tile_id)
	$Label.text = Game.CONST_DATA.tiles[tile_id].name
	
func _ready():
	$Label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_hovered():
		material.set_shader_param("enabled", true)
		$Label.show()
	else:
		material.set_shader_param("enabled", false)
		$Label.hide()

func _on_InventoryItem_button_down():
	modulate.a = 0.5
	Cursor.drag(texture_normal, Vector2(-16,-16))
func _on_InventoryItem_button_up():
	if Cursor.drag_texture.is_hovering(Game.INV_SELECTED):
		Game.equip_item(tile_id)
	modulate.a = 1.0
	Cursor.drag(null)
	
