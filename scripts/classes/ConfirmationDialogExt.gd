extends ConfirmationDialog
class_name ConfirmationDialogExt

signal chosen(choice)
func _on_confirmed():
	_on_chosen(true)
func _on_popup_hide():
	# 'popup_hide' fucking fires BEFORE 'confirmed', so fuck me I guess.
	call_deferred("_on_chosen", false)
	# ALSO we must use call_deferred on "delicate" to prevent UI inputs bleeding.
	Cutscenes.delicate_deferred(false)

func _on_chosen(choice):
	yield(Engine.get_main_loop(), "idle_frame")
	emit_signal("chosen", choice)

func _ready():
	var _r = connect("confirmed", self, "_on_confirmed")
	_r = connect("popup_hide", self, "_on_popup_hide")
