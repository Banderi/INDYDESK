extends TextureButton

func set_item_name(text):
#	pass
	$Label.text = text
#	$Label.text = text.replace(" ","\n")
#	$Label.bbcode_text = "[center]" + text

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
	modulate.a = 1.0
	Cursor.drag(null)
