extends Control

func load_indy():
	Game.load_daw("E:/Games/INDYDESK/DESKTOP.DAW")
	Game.generate_tileset($Floor.tile_set)
	Game.generate_spritesheets($HERO.attack_spritesheet)
#	$Sprite.texture = texture_from_data(Game.SECTIONS["STUP"], 288, 288, PALETTE_INDY)


#	hero sprites
	$HERO.sprite.frames = Game.SECTIONS.CHAR.HERO.sprites
	$HERO.sprite.disconnect("animation_finished", $HERO, "_on_Character_animation_finished")
	$HERO.sprite.connect("animation_finished", $HERO, "_on_Character_animation_finished")

func load_zone(id):
	var zone_data = Game.load_zone(id)
#	var tiles_htsp = $Hotspots
#	var tiles_mnstr = $Monsters
	
	$Label.text = "Type: <%d> %s" % [zone_data.type,Log.get_enum_string(Game.ZonesYoda, zone_data.type)]
	$Label.text += "\n\nHotspots:"
	for hotspot in Game.SECTIONS.HTSP.get(id,[]):
		$Label.text += "\n(%d,%d) <%d> %s %s" % [
			hotspot.x, hotspot.y,
			hotspot.type, Log.get_enum_string(Game.HotspotsYoda, hotspot.type),
			"" if hotspot.args == 65535 else str("(",hotspot.args,")")
		]
#		tiles_htsp.set_cell(hotspot.x,hotspot.y,0)
	
	$Label.text += "\n\nMonsters:"
	for monster in Game.SECTIONS.ZAUX[id].monsters:
		$Label.text += "\n(%d,%d) <%d> %s" % [
			monster.x, monster.y,
			monster.id, "??"#, Log.get_enum_string(HotspotsYoda, hotspot.type),
			#"" if hotspot.args == 65535 else str("(",hotspot.args,")")
		]
#		tiles_mnstr.set_cell(monster.x,monster.y,0)
	$Label.text += "\n\nRequired items:"
	for item in Game.SECTIONS.ZAUX[id].items:
		$Label.text += "\n<%d> %s" % [
			item,
			"??"#, Log.get_enum_string(HotspotsYoda, hotspot.type),
			#"" if hotspot.args == 65535 else str("(",hotspot.args,")")
		]
	$Label.text += "\n\nRewards:"
	for item in Game.SECTIONS.ZAX2[id]:
		$Label.text += "\n<%d> %s" % [
			item,
			"??"#, Log.get_enum_string(HotspotsYoda, hotspot.type),
			#"" if hotspot.args == 65535 else str("(",hotspot.args,")")
		]

	$Label.text += "\n\nNPCs:"
	for npc in Game.SECTIONS.ZAX3[id]:
		$Label.text += "\n<%d> %s" % [
			npc,
			"??"#, Log.get_enum_string(HotspotsYoda, hotspot.type),
			#"" if hotspot.args == 65535 else str("(",hotspot.args,")")
		]

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.FLOOR_TILES = $Floor
	Game.WALL_TILES = $Walls
	Game.ROOF_TILES = $Ceiling
	load_indy()
	load_zone(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Label2.text = "state: %s\n" % [Log.get_enum_string($HERO.States, $HERO.state)]
	$Label2.text += "tile_current: %s\n" % [$HERO.tile_current]
	$Label2.text += "tile_target: %s\n" % [$HERO.tile_target]
	$Label2.text += "linked_object: %s\n" % [$HERO.linked_object]
	
	$ColorRect.rect_position = Game.to_vector($HERO.tile_target)
	$ColorRect2.rect_position = Game.to_vector($HERO.tile_current)


func _on_Button_pressed():
#	generate_tileset()
#	generate_spritesheets()
#	load_indy()
#	$SpinBox.value = 0
#	for n in $ScrollContainer/VBoxContainer.get_children():
#		save_texture(n.texture, "")
	load_zone(0)


func _on_SpinBox_value_changed(value):
	load_zone(int(value))
