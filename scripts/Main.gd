extends Control

onready var HERO = $Walls/HERO
onready var tile_set = $Floor.tile_set

func load_indy():
	Game.load_daw("E:/Games/INDYDESK/DESKTOP.DAW")
	Game.generate_tileset(tile_set)
	Game.generate_spritesheets()
	Game.load_splashscreen($SplashScreen)

func print_zone_vars():
	var zone_data = Game.CONST_DATA.zones[Game.CURRENT_ZONE]
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
	label.text += "\n\nActions:"
	for a in zone_data.actions.size():
		var action = zone_data.actions[a]
#		label.text += "\n(%d,%d) <%d> %s %s %s" % [
#			hotspot.x, hotspot.y,
#			hotspot.type, Log.get_enum_string(Game.Hotspots, hotspot.type),
#			"" if hotspot.args == 65535 else str("(",hotspot.args,")"),
#			"" if hotspot.enabled else "(off)"
#		]
		label.text += "\n%d: %s%s" % [
			a, action.name, "" if action.enabled else " (OFF)"
		]
	
	
	label.text += "\n\nMonsters:"
	for monster in zone_data.monsters:
		label.text += "\n(%d,%d) <%d> %s" % [
			monster.x, monster.y,
			monster.id, Game.get_tile_params(monster.id).name
		]
#		tiles_mnstr.set_cell(monster.x,monster.y,0)
	label.text += "\n\nRequired items:"
	for item in zone_data.required_items:
		label.text += "\n<%d> %s" % [item, Game.get_tile_params(item).name]
	label.text += "\n\nRewards:"
	for item in zone_data.reward_items:
		label.text += "\n<%d> %s" % [item, Game.get_tile_params(item).name]
	label.text += "\n\nNPCs:"
	for npc in zone_data.npcs:
		label.text += "\n<%d> %s" % [npc, Game.get_tile_params(npc).name]

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.WORLD_ROOT = self
	Game.UI_ROOT = $UI
	Game.FLOOR_TILES = $Floor
	Game.WALL_TILES = $Walls
	Game.ROOF_TILES = $Ceiling
	Game.INV_UI_LIST = $UI/SIDE/Inventory/VBoxContainer
	Game.INV_SELECTED = $UI/SIDE/Selected
	Cursor.backdrop = self
	Cursor.drag_texture = $UI/DRAG
	Sounds.SOUND_IMMEDIATE_STREAM = $AudioStreamPlayer
	Sounds.SOUND_IMMEDIATE_MIDI = $MidiPlayer
	$UI/Fade.modulate.a = 1.0
	load_indy()
	
#	Game.new_game()
	Game.load_game("E:/Games/INDYDESK/3.WLD")
#	Game.load_zone(108, Vector2())

#	Game.speech_bubble(HERO.tile_current,"Ahh, my home away from home...")
#	Game.speech_bubble(HERO.tile_current,"Ahh, my home away from home...\n\nLINE3...\nLINE4...")
	
#	$SplashScreen.texture = texture_from_data(Game.SECTIONS["STUP"], 288, 288, PALETTE_INDY)
	
#	hero sprites
	HERO.sprite.frames = Game.HERO_SPRITESHEET
	HERO.sprite.disconnect("animation_finished", HERO, "_on_Character_animation_finished")
	HERO.sprite.connect("animation_finished", HERO, "_on_Character_animation_finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI/FPS.text = str(Engine.get_frames_per_second()," FPS")
	Cursor.cursor_setting_loop()
	
	$UI/Label2.text = "fade: %s\n" % [Game.FADE.modulate.a]
	
	# audio monitoring tests
	$UI/Label3.text = str(Sounds.SOUND_IMMEDIATE_STREAM.playing)
	var bus_idx = AudioServer.get_bus_index("Master")
	var audiocapture = AudioServer.get_bus_effect(0,0) as AudioEffectCapture
	var frames = audiocapture.get_buffer(audiocapture.get_frames_available())
	if frames.size() != 0:
		$UI/Label3/Bars/L.rect_size.y = 10 + abs(frames[0].x) * 1000.0
		$UI/Label3/Bars/R.rect_size.y = 10 + abs(frames[0].y) * 1000.0
	else:
		$UI/Label3/Bars/L.rect_size.y = 10
		$UI/Label3/Bars/R.rect_size.y = 10
	
	if !Game.is_in_game():
		return
	$UI/Label2.text += "current_zone: <%s> %s\n" % [Game.CURRENT_ZONE, Game.CONST_DATA.zones[Game.CURRENT_ZONE].name]
	$UI/Label2.text += "rooms_stack: %s\n" % [Game.ROOMS_STACK]
	$UI/Label2.text += "zone_variable: %s\n" % [Game.GAME_DATA.zones[Game.CURRENT_ZONE].variable]
	$UI/Label2.text += "zone_random: %s\n" % [Game.GAME_DATA.zones[Game.CURRENT_ZONE].random]
	$UI/Label2.text += "GLOBAL_VAR: %s\n" % [Game.GLOBAL_VAR]
	$UI/Label2.text += "JUST_ENTERED_ZONE: %s\n" % [Game.JUST_ENTERED_ZONE]
	$UI/Label2.text += "JUST_ENTERED_ZONE_BY_VEHICLE: %s\n" % [Game.JUST_ENTERED_ZONE_BY_VEHICLE]
	$UI/Label2.text += "can_control_hero: %s\n" % [Game.can_control_hero()]
	$UI/Label2.text += "is_won: %s\n" % [Game.GAME_DATA.is_won]
	
	$UI/Label2.text += "\nstate: %s\n" % [Log.get_enum_string(HERO.States, HERO.state)]
	$UI/Label2.text += "last_attempted_input: %s\n" % [HERO.last_attempted_input]
	$UI/Label2.text += "tile_current: %s rel. %s\n" % [HERO.tile_current, Game.to_zone_relative(HERO.tile_current)]
	$UI/Label2.text += "tile_target: %s rel. %s\n" % [HERO.tile_target, Game.to_zone_relative(HERO.tile_target)]
	$UI/Label2.text += "linked_object: %s\n" % [HERO.linked_object]
	
#	$ColorRect.rect_position = Game.to_vector(HERO.tile_target)
#	$ColorRect2.rect_position = Game.to_vector(HERO.tile_current)

	$ColorRect.rect_position = Game.to_vector(HERO.tile_target)
	$ColorRect2.rect_position = Game.to_vector(HERO.tile_current)
	
#	HERO.position += Vector2(2.0*randf()-1.0,2.0*randf()-1.0) * 25.0

	
	print_zone_vars()
	
#	if Game.JUST_ENTERED_ZONE:
#		print_zone_vars()


func _on_Button_pressed():
	Game.load_game("E:/Games/INDYDESK/3.WLD")
#	Game.play_sound(14)
#	Game.speech_bubble(HERO.tile_current,"Ahh, my home away from home...")
#	Game.speech_bubble(HERO.tile_current,"Ahh, my home away from home...\n\nLINE3...\nLINE4...")
#	Game.load_zone(120, Vector2())
#	Game.load_zone(121, Vector2(0, -18))
#	generate_tileset()
#	generate_spritesheets()
#	load_indy()
#	$SpinBox.value = 0
#	for n in $ScrollContainer/VBoxContainer.get_children():
#		save_texture(n.texture, "")
	pass


func _on_SpinBox_value_changed(value):
	Game.load_zone(int(value), Vector2())
	pass
