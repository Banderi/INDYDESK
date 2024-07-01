extends Node
# ANTIMONY 'Cursor' by Banderi --- v1.0

var backdrop : Control = null
var cursor_shape = null
func push(cursor):
	cursor_shape = cursor
func cursor_setting_loop():
	if cursor_shape == null:
		cursor_shape = Input.CURSOR_ARROW
	backdrop.set_default_cursor_shape(cursor_shape)
	cursor_shape = null
	if drag_texture != null:
		drag_texture.rect_position = get_viewport().get_mouse_position() + drag_offset

var drag_texture = null
var drag_offset = Vector2()
func drag(texture, cursor_offset = Vector2()):
	if texture == null:
#		drag_texture.free()
#		drag_texture = null
		drag_texture.hide()
	else:
#		if drag_texture == null:
#			drag_texture = TextureRect.new()
#			backdrop.add_child(drag_texture)
		drag_texture.show()
		drag_texture.texture = texture
		drag_offset = cursor_offset
	cursor_setting_loop()

func hide():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func show():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
