extends MidiPlayer

func _ready():
	play()

func _on_MidiPlayer_finished():
	queue_free()
