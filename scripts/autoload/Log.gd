extends Node
# ANTIMONY 'Log' by Banderi --- v1.0

var LOG_EVERYTHING = []
var LOG_ENGINE = []
var LOG_ERRORS = []
func get_origin(line : String):
	var i = line.find("11][") + 4
	var j = line.find("]:")
	var app_name = line.substr(i, j-i)
	return app_name

var LOG_CHANGED = false

const MAX_LINES_IN_CONSOLE = 200
func limit_array(arr, limit = MAX_LINES_IN_CONSOLE):
	if arr.size() > limit:
		arr.pop_front()

func get_enum_string(enums, value):
	return enums.keys()[value]
func get_timestamp():
	var d = OS.get_datetime()
	return "%04d/%02d/%02d %02d:%02d:%02d -- " % [d.year, d.month, d.day, d.hour, d.minute, d.second]

func generic(from, message_text, iserror = false):
	var timestamp = get_timestamp()

	# app name (with brackets)
	var app_name = ""
	if from is String:
		app_name = from
	elif from != null:
		app_name = from.APP_NAME if "APP_NAME" in from else from.name
	var plain_appname = str("[", app_name, "]: ") if app_name != "" else ""
	
	# plain text for normal console
	var plain_msg = str(timestamp, plain_appname, message_text)
	print(plain_msg)
	
	# colored BBCode text
	var bbcode_msg = str("[color=#888888]", timestamp, "[/color][color=#00aa11]", plain_appname, "[/color]")
	if iserror:
		bbcode_msg += str("[color=#ee1100]", message_text, "[/color]")
	else:
		bbcode_msg += str("[color=#ffffff]", message_text, "[/color]")
	
	# record on "EVERYTHING" regardless of nature of message
	LOG_EVERYTHING.push_back(bbcode_msg)
	limit_array(LOG_EVERYTHING)
	
	# record on "ERRORS" if it's an error
	if iserror:
		LOG_ERRORS.push_back(bbcode_msg)
		limit_array(LOG_ERRORS)
		push_error(plain_msg)
	
	# record on node's custom log stack (if present)
	if from != null && "LOG" in from:
		from.LOG.push_back(bbcode_msg)
		limit_array(from.LOG)
	# record under "ENGINE" otherwise
	else:
		LOG_ENGINE.push_back(bbcode_msg)
		limit_array(LOG_ENGINE)
	
	LOG_CHANGED = true
func error(from, err, message_text):
	var error_text = "ERROR: "
	if err != null:
		error_text += str("(", err, ":", get_enum_string(GlobalScope.Error, err), ") ")
	error_text += message_text
	return generic(from, error_text, true)

func clear_log(from):
	from.LOG = []
	LOG_CHANGED = true
func clear_all_logs(plus_nodes : Array = []):
	LOG_EVERYTHING = []
	LOG_ENGINE = []
	LOG_ERRORS = []
	LOG_CHANGED = true
	for n in plus_nodes:
		clear_log(n)
