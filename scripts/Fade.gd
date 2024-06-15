extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.FADE = self

var fade_target = 0
signal fade_done

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade_target != 0:
		modulate.a += fade_target * delta * 2.0
		if modulate.a <= 0.0 || modulate.a >= 1.0:
			modulate.a = clamp(fade_target,0,1)
			fade_target = 0
			emit_signal("fade_done")
