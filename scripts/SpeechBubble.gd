extends Control

const LINE_HEIGHT = 15
onready var PANEL = $Panel
onready var TEXT_DIV = $Panel/Text
onready var TEXT_BOX = $Panel/Text/Text
onready var FONT = TEXT_BOX.get_font("normal_font")
onready var SPACE_WIDTH = FONT.get_string_size(" ").x

export var IS_FLIPPED = false
var TOTAL_LINES = 2
func set_text(text):
	TEXT_BOX.rect_size.y = 0
	TEXT_BOX.text = text
	
	# count actual total lines accounting for auto wrapping
	TOTAL_LINES = 0
	for line in text.split("\n"):
		
		# minimum for each hard-broken line is "1", obviously.
		var lines_req = 1
		var line_length = 0
		for word in line.split(" "):
			var word_length = FONT.get_string_size(word).x
			
			# if line length exceeds box size, wrap
			line_length += (SPACE_WIDTH + word_length)
			if line_length > TEXT_BOX.rect_size.x:
				lines_req += 1
				line_length = word_length
		
		# add final tally to line counter!
		TOTAL_LINES += lines_req

	# hide scroll buttons if not needed
	if TOTAL_LINES < 6:
		$Panel/BtnUp.hide()
		$Panel/BtnDown.hide()
	
	# update box size
	if TOTAL_LINES > 2:
		PANEL.rect_size.y = PANEL.rect_min_size.y + LINE_HEIGHT * min(TOTAL_LINES - 2, 3)
	
	# shift speech bubble upwards or downwards depending on direction of free space on screen
	if IS_FLIPPED: # TODO?
		pass
	else:
		PANEL.rect_position.y = -54 - (PANEL.rect_size.y - PANEL.rect_min_size.y)
	
	# update text scroll & global positioning
	scroll(0)
	follow_tile()

var LINE = 0
func scroll(dir):	
	var max_line = max(0,TOTAL_LINES - 5)
	LINE = clamp(LINE + dir, 0, max_line)
	$Panel/BtnUp.disabled = LINE == 0
	$Panel/BtnDown.disabled = LINE == max_line
	TEXT_BOX.rect_position.y = -LINE_HEIGHT * LINE

var TILE = null
func follow_tile():
	rect_position = Game.to_vector(TILE) + Vector2(2,-20) + OS.window_size / 2 - Game.CAMERA.position
	pass

func _on_BtnUp_pressed():
	scroll(-1)
func _on_BtnDown_pressed():
	scroll(1)

func _on_BtnContinue_pressed():
	Game.SPEECH_PLAYING = null
	queue_free()

func _input(event):
	if Input.is_action_pressed("scroll_up"):
		scroll(-1)
	if Input.is_action_pressed("scroll_down"):
		scroll(1)
	if Input.is_action_just_pressed("ui_cancel"):
		_on_BtnContinue_pressed()

func _process(delta):
	follow_tile()
