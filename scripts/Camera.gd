extends Camera2D

func _process(delta):
	position += (Game.HERO_ACTOR.position + Vector2(75,0) - position) * min(delta * 10.0, 1.0)

func _ready():
	Game.CAMERA = self
