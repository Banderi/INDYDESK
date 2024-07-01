extends Node
# ANTIMONY 'Sounds' by Banderi --- v1.0

#onready var SOUND3D_SCN = load("res://scenes/FX/Sound3D.tscn")
onready var SOUND_SCN = load("res://scenes/FX/Sound.tscn")
onready var MIDI_SCN = load("res://scenes/FX/MIDI.tscn")

# Audio buses are:
# - "Master"
# - "SFX"
# - "Music"

func get_volume(bus):
	var bus_index = AudioServer.get_bus_index(bus)
	var db = AudioServer.get_bus_volume_db(bus_index)
	var linear = db2linear(db)
	return linear
func set_volume(bus, value):
	var bus_index = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, linear2db(value))

var SOUND_IMMEDIATE_STREAM : AudioStreamPlayer = null
var SOUND_IMMEDIATE_MIDI : MidiPlayer = null
var IS_LOCKED = false
func play_sound_immediate(sound: String, volume : float, bus : String, pitch_rnd : float = 0.0, from : float = 0.0):
	if ".MID" in sound:
		SOUND_IMMEDIATE_MIDI.volume_db = linear2db(volume - 0.65)
		SOUND_IMMEDIATE_MIDI.bus = bus
		SOUND_IMMEDIATE_MIDI.file = str("res://audio/sfx/",sound)
		SOUND_IMMEDIATE_STREAM.play(from)
	else:
		SOUND_IMMEDIATE_STREAM.volume_db = linear2db(volume)
		if pitch_rnd != 0.0:
			SOUND_IMMEDIATE_STREAM.pitch_scale = rand_range(1.0 - pitch_rnd, 1.0 + pitch_rnd)
		SOUND_IMMEDIATE_STREAM.bus = bus
		SOUND_IMMEDIATE_STREAM.stream = load(str("res://audio/sfx/",sound))
		SOUND_IMMEDIATE_STREAM.play(from)

func play_sound(sound: String, position, volume : float, bus : String, pitch_rnd = 0.0):
	var node = null
	if ".MID" in sound:
		node = MIDI_SCN.instance()
		node.volume_db = linear2db(volume - 0.65)
		node.bus = bus
		node.file = str("res://audio/sfx/",sound)
	else:
		if position == null:
			node = SOUND_SCN.instance()
			node.volume_db = linear2db(volume)
#		else:
#			node = SOUND3D_SCN.instance()
#			node.translation = position
#			node.unit_db = linear2db(volume)
		if pitch_rnd != 0.0:
			node.pitch_scale = rand_range(1.0 - pitch_rnd, 1.0 + pitch_rnd)
		node.bus = bus
		node.stream = load(str("res://audio/sfx/",sound))
	Game.WORLD_ROOT.add_child(node)
	node.set_pause_mode(2) # Set pause mode to Process
	node.set_process(true)
	return node

var MUSIC_PLAYER1 = null
var MUSIC_PLAYER2 = null
var AMBIENT = null
func play_music(music: String, volume : float = 1.0):
	MUSIC_PLAYER1.volume_db = linear2db(volume * 0.4)
	var newstream = load(str("res://audio/music/",music))
	if MUSIC_PLAYER1.stream != newstream:
		MUSIC_PLAYER1.stream = newstream
		MUSIC_PLAYER1.playing = true
func play_music2(music: String, volume : float = 1.0):
	MUSIC_PLAYER2.volume_db = linear2db(volume * 0.4)
	var newstream = load(str("res://audio/music/",music))
	if MUSIC_PLAYER2.stream != newstream:
		MUSIC_PLAYER2.stream = newstream
		MUSIC_PLAYER2.playing = true

func change_filter(bus : String, filter : int, param : String, value):
	var bus_index = AudioServer.get_bus_index(bus)
	var effect = AudioServer.get_bus_effect(bus_index, filter)
	if effect == null:
		return
	if param in effect:
		effect.set(param, value)
func activate_filter(bus : String, filter : int, enabled : bool):
	var bus_index = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_effect_enabled(bus_index, filter, enabled)


func play_ambient(ambient: String, volume : float = 1.0):
	if ambient == "":
		AMBIENT.playing = false
		return
	AMBIENT.volume_db = linear2db(volume * 0.5)
	var newstream = load(str("res://audio/sfx/",ambient))
	if AMBIENT.stream != newstream:
		AMBIENT.stream = newstream
		AMBIENT.playing = true

func _ready():
	self.set_pause_mode(2) # Set pause mode to Process
	set_process(true)
