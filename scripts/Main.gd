extends Control

onready var HERO = $Walls/HERO
onready var tile_set = $Floor.tile_set

func load_indy():
	Game.load_daw("E:/Games/INDYDESK/DESKTOP.DAW")
	Game.generate_tileset(tile_set)
	Game.generate_spritesheets()
	Game.load_splashscreen($SplashScreen)

func load_zone(id, map_origin):
	var zone_data = Game.load_zone(id, map_origin)
#	var tiles_htsp = $Hotspots
#	var tiles_mnstr = $Monsters

	var label = $UI/Label
	
	label.text = "Type: <%d> %s" % [zone_data.type,Log.get_enum_string(Game.Zones, zone_data.type)]
	label.text += "\n\nHotspots:"
	for hotspot in zone_data.hotspots:
		label.text += "\n(%d,%d) <%d> %s %s %s" % [
			hotspot.x, hotspot.y,
			hotspot.type, Log.get_enum_string(Game.Hotspots, hotspot.type),
			"" if hotspot.args == 65535 else str("(",hotspot.args,")"),
			"" if hotspot.enabled else "(off)"
		]
#		tiles_htsp.set_cell(hotspot.x,hotspot.y,0)
	
	label.text += "\n\nMonsters:"
	for monster in zone_data.monsters:
		label.text += "\n(%d,%d) <%d> %s" % [
			monster.x, monster.y,
			monster.id, Game.get_tile_data(monster.id).name
		]
#		tiles_mnstr.set_cell(monster.x,monster.y,0)
	label.text += "\n\nRequired items:"
	for item in zone_data.required_items:
		label.text += "\n<%d> %s" % [item, Game.get_tile_data(item).name]
	label.text += "\n\nRewards:"
	for item in zone_data.reward_items:
		label.text += "\n<%d> %s" % [item, Game.get_tile_data(item).name]
	label.text += "\n\nNPCs:"
	for npc in zone_data.npcs:
		label.text += "\n<%d> %s" % [npc, Game.get_tile_data(npc).name]

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.WORLD_ROOT = self
	Game.FLOOR_TILES = $Floor
	Game.WALL_TILES = $Walls
	Game.ROOF_TILES = $Ceiling
	load_indy()
#	load_zone(120, Vector2())
	Game.new_game()
#	Game.load_zone(120)
#	load_zone(121)
	
#	$SplashScreen.texture = texture_from_data(Game.SECTIONS["STUP"], 288, 288, PALETTE_INDY)
	
#	hero sprites
	HERO.sprite.frames = Game.HERO_SPRITESHEET
	HERO.sprite.disconnect("animation_finished", HERO, "_on_Character_animation_finished")
	HERO.sprite.connect("animation_finished", HERO, "_on_Character_animation_finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UI/Label2.text = "current_zone: %s\n" % [Game.CURRENT_ZONE]
	$UI/Label2.text += "rooms_stack: %s\n" % [Game.ROOMS_STACK]
	$UI/Label2.text += "state: %s\n" % [Log.get_enum_string(HERO.States, HERO.state)]
	$UI/Label2.text += "tile_current: %s\n" % [HERO.tile_current]
	$UI/Label2.text += "tile_target: %s\n" % [HERO.tile_target]
	$UI/Label2.text += "linked_object: %s\n" % [HERO.linked_object]
	
#	$ColorRect.rect_position = Game.to_vector(HERO.tile_target)
#	$ColorRect2.rect_position = Game.to_vector(HERO.tile_current)
	
#	HERO.position += Vector2(2.0*randf()-1.0,2.0*randf()-1.0) * 25.0

	$UI/FPS.text = str(Engine.get_frames_per_second()," FPS")


func _on_Button_pressed():
#	load_zone(120)
	load_zone(120, Vector2())
#	Game.load_zone(120, Vector2())
#	Game.load_zone(121, Vector2(0, -18))
#	generate_tileset()
#	generate_spritesheets()
#	load_indy()
#	$SpinBox.value = 0
#	for n in $ScrollContainer/VBoxContainer.get_children():
#		save_texture(n.texture, "")
#	load_zone(120)
	pass


func _on_SpinBox_value_changed(value):
	load_zone(int(value), Vector2())
