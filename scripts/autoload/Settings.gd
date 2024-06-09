extends Node

# settings -- these are automatically iterated over, loaded and saved!
# DO NOT ADD VARS TO THIS SCRIPT WHICH YOU DO NOT INTEND TO WRITE TO SETTING FILES.
# var setting1 = value
# var setting2 = value
# var setting3 = value

var volume_master = 1.0
var volume_sfx = 1.0
var volume_music = 1.0
var volume_ambient = 1.0

var camera_sensitivity_x = 1.0
var camera_sensitivity_y = 1.0
var camera_lockon_displacement = 0.5
var camera_lockon_use_center_of_screen = false
var camera_invert_y = false
var controller_deadzone = 0.1

var custom_keybinds = {}

var DEFAULT_VALUES = {}
func cache_defaults():
	for property in settings_list():
		var variable = property.name
		DEFAULT_VALUES[variable] = get(variable)
func settings_list():
	return get_script().get_script_property_list()

# settings IO
const DATA_PATH = "user://data.json"
func save_user_data(export_file_path = ""):
	var settings = {}
	for property in settings_list():
		var variable = property.name
		if variable != "DEFAULT_VALUES":
			settings[variable] = get(variable)

	IO.write(export_file_path if export_file_path != "" else DATA_PATH, to_json(settings))
func load_user_data(import_file_path = ""):
	if DEFAULT_VALUES.size() == 0:
		cache_defaults()
	var fdata = IO.read(import_file_path if import_file_path != "" else DATA_PATH, true)
	if fdata != null:
		var data = parse_json(fdata)
		for variable in data:
			if variable != "DEFAULT_VALUES":
				set(variable, data[variable])

		# HERE: refresh/reload settings in the game
	elif import_file_path == "":
		Log.generic(null,str("No user data file found, creating a new one..."))
		save_user_data()
func update(variable, value, force = false, save = true):
	if variable in self && (force || get(variable) != value):
		set(variable, value)
		if save:
			save_user_data()
func update_dictionary(dictionary, key, value, force = false):
	if dictionary in self && (!get(dictionary).has(key) || force || get(dictionary).get(key) != value):
			get(dictionary)[key] = (value)
			save_user_data()
func clear_dictionary(dictionary, key = null):
	if dictionary in self:
		if key == null:
			get(dictionary).clear()
		elif key in get(dictionary):
			get(dictionary).erase(key)
		save_user_data()
func get_default(variable):
	if variable in self:
		return DEFAULT_VALUES[variable]

func _ready():
	cache_defaults()
