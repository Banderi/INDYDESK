extends Camera2D

func _process(delta):
	position += (Game.HERO_ACTOR.position - position) * min(delta * 10.0, 1.0)
