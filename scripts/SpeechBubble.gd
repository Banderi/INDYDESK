extends Control

var IS_FLIPPED = false
func set_text(text):
	$Panel/Text.text = text
	var lines = text.count("\n") + $Panel/Text.get_font("normal_font").get_string_size($Panel/Text.text).x / 164
	if lines < 2:
		$Panel/BtnUp.hide()
		$Panel/BtnDown.hide()
	else:
		$Panel.rect_size.y += min(3,lines)*13
	
	if IS_FLIPPED:
		pass
	else:
		$Panel.rect_position.y = -49 - ($Panel.rect_size.y - 31)

func _on_BtnContinue_pressed():
	Game.SPEECH_PLAYING = null
	queue_free()
