# Script for updating the gui
# Manages:
#    Dialog
#    Visuals
extends CanvasLayer

signal textbox_end

const MAX_ENERGY = 4

## Hides all GUI elements
func hide():
	gui.visible = false
## Shows all GUI elements
func show():
	gui.visible = true

## Updates GUI for a clean reset for new level
func start(stageNum):
	stageName.text = "LV." + str(stageNum)
	energy.value = 4

# Health
func update_health(value, max_value):
	energy.set_max(max_value)
	energy.set_value(value)
func heal():
	energy.value = energy.value + 1
func reset_energy():
	energy.value = MAX_ENERGY

# Lives
func set_lives(num_lives):
	lives.text = str(num_lives)

# Pons
func set_pons(amo):
	pons.text = "    " + str(amo)

# Boss energy
func startBossBattle(life):
	bossEnergy.value = life
	# TODO: Show boss health

# Score
func set_score(amo):
	playerScore.set_text("%06d" % amo)
func set_score_mult(amo):
	playerScoreMult.set_text("x%d:" % amo)
	playerScoreMultAmo = amo
	if amo == 1:
		playerScoreMult.visible = false
	else:
		playerScoreMult.visible = true

func set_gui_size(size):
	sizeAnimator.play(size)

onready var gui = $Player
onready var energy = $Player/Energy
onready var bossEnergy = $Player/BossArea/BossEnergy
onready var playerScore = $Player/ScoreArea/ScoreNum
onready var playerScoreMult = $Player/ScoreArea/Multiplicity
var playerScoreMultAmo = 1

onready var sizeAnimator = $AnimationPlayer

onready var stageName = $Player/StageName
onready var lives = $Player/LiveNum
onready var pons = $Player/PonsNum

onready var scoreArea = $Player/ScoreArea
onready var bossArea = $Player/BossArea

### ------------------------------
### DIALOG
### -------------------------------

const letters_per_sec = 20.0
var text_to_run = []
var text_crawl_func
var dialog_active = false
var cur_speaking_name = ""

func _process(delta):
	if text_crawl_func is GDScriptFunctionState:
		# Pre-empt textboxes
		if dialog.visible and Input.is_action_just_pressed("ui_B"):
			text_crawl_func = null
			# Don't run any more textboxes by the speaking character
			while text_to_run.front() != null \
				and text_to_run.front().has("name") \
				and text_to_run.front().name == cur_speaking_name:
				text_to_run.pop_front()
			# After popping, add delay so player won't activate powers
			# on accident
			var text_queue_finished = true
			for textbox in text_to_run:
				if !textbox.has("freeze_player") and !textbox.has("unfreeze_player") \
					and !textbox.has("enable") and !textbox.has("disable"):
					text_queue_finished = false
			if text_queue_finished:
				text_to_run.push_front({delay=0.25})
		else:
			text_crawl_func = text_crawl_func.resume(delta)
	elif text_to_run.size() > 0:
		var next_box = text_to_run.pop_front()
		start_dialog(next_box)
	elif dialog_active:
		end_dialog()
	if get_tree().paused and playerScoreMultAmo > 1:
		playerScoreMult.visible = true

func _unhandled_input(event):
	if event.is_action_pressed("toggle_hud"):
		gui.visible = !gui.visible

func queue_text(dialog_starter, textbox : Dictionary):
	queue(dialog_starter, [textbox])

func queue_dialog(dialog_starter, textbox_num : int):
	var textbox = textboxes.get_dialog(textbox_num)
	queue(dialog_starter, textbox)

func queue(dialog_starter, textbox):
	for textbox_dict in textbox:
		textbox_dict.starter = dialog_starter
	text_to_run += textbox
	if !(text_crawl_func is GDScriptFunctionState):
		var next_box = text_to_run.pop_front()
		start_dialog(next_box)

func start_dialog(next_box):
	dialog_active = true
	PlayerGameManager.pause_except([])
	cur_speaking_name = ""
	if next_box.has("name"):
		gui.visible = false
		dialog.visible = true
		dialogName.text = next_box.name
		cur_speaking_name = next_box.name
		dialogText.text = next_box.text
		dialogText.lines_skipped = 0
		# Start text crawl
		text_crawl_func = crawl(next_box.text.length())
	elif next_box.has("signal"):
		next_box.starter.emit_signal(next_box.signal)
		# Wait for program to return signal that we can continue scene
		if next_box.has("delay"):
			gui.visible = true
			dialog.visible = false
			text_crawl_func = delay(next_box['delay'])
	elif next_box.has("enable"):
		for body in next_box['enable']:
			body.set_pause_mode(PAUSE_MODE_PROCESS)
	elif next_box.has("disable"):
		for body in next_box['disable']:
			body.set_pause_mode(PAUSE_MODE_INHERIT)
	elif next_box.has("unfreeze_player"):
		next_box['unfreeze_player'].set_freeze(false)
	elif next_box.has("freeze_player"):
		next_box['freeze_player'].set_freeze(true)
	elif next_box.has("level"):
		PlayerGameManager.start_level(next_box['level'])
	elif next_box.has("delay"):
		gui.visible = true
		dialog.visible = false
		text_crawl_func = delay(next_box['delay'])

func end_dialog():
	dialog_active = false
	PlayerGameManager.unpause()
	gui.visible = true
	dialog.visible = false
	emit_signal("textbox_end")

func get_printed_lines():
	return dialogText.lines_skipped + dialogText.get_line_count() * dialogText.percent_visible

func delay(wait_time):
	var time_passed = 0
	while time_passed < wait_time:
		var delta = yield()
		time_passed += delta

func crawl(_text_length):
	# Text crawl
	dialogText.percent_visible = 0
	var lettersVisible = 0.0
	var speed = 1
	while get_printed_lines() < dialogText.get_line_count():
		var delta = yield()
		lettersVisible += delta * speed * letters_per_sec
		if dialogText.visible_characters >= 39:
			# Wait for user input
			while(!Input.is_action_just_pressed("ui_A")):
				yield()
			dialogText.lines_skipped += 2
			lettersVisible -= 40
			dialogText.set_visible_characters(int(lettersVisible))
			yield()
		dialogText.set_visible_characters(int(lettersVisible))
		if Input.is_action_just_pressed("ui_A"):
			lettersVisible = 38
	yield()
	# Wait for user input
	while(!Input.is_action_just_pressed("ui_A")):
		yield()
	return

## Sets score multiplicity to visible or invisible
## based on the amount of time left. Visualizes the speed at
## which multiplicity time is depleting
func notify_multiplicity_time(time):
	if time < 0.1:
		playerScoreMult.visible = true
	elif time < 0.25:
		playerScoreMult.visible = false
	elif time < 0.4:
		playerScoreMult.visible = true
	elif time < 0.55:
		playerScoreMult.visible = false
	elif time < 0.7:
		playerScoreMult.visible = true
	elif time < 0.85:
		playerScoreMult.visible = false

onready var dialog = $DialogBox
onready var dialogName = $DialogBox/Name
onready var dialogText = $DialogBox/Dialog
onready var textboxes = game_dialog.new()

### ------------------------------
### Screen Resolution
### -------------------------------

var cur_resolution : Vector2 = Vector2.ZERO
func set_screen_resolution(new_size : Vector2) -> void:
	cur_resolution = new_size
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, new_size)
	# Resize window if not maximized
	if !OS.window_maximized:
		#Find closest multiple of new resolution near current window size
		var dist_to_cur_size = OS.get_window_size().distance_to(new_size)
		var multiplier : int = 1
		for mult in range(2, 5):
			if OS.get_window_size().distance_to(new_size*mult) < dist_to_cur_size \
				and new_size.x*mult < OS.get_screen_size().x and new_size.y*mult < OS.get_screen_size().y:
				multiplier = mult
			OS.set_window_size(new_size * multiplier)

func get_screen_resolution() -> Vector2:
	return cur_resolution

### ------------------------------
### Palette
### -------------------------------

func set_palette(palette_name):
	palette_controller.set_palette(palette_name)
func set_brightness(val):
	palette_controller.set_brightness(val)

### ------------------------------
### Parallax
### -------------------------------

onready var palette_controller = $PaletteFilter

func cover() -> float:
	if !Constants.PHOTOSENSITIVE_MODE:
		cover_animator.play("cover")
		return 0.6
	else:
		cover_animator.play("cover (slow)")
		return 1.4
	return 1.0
func reveal() -> float:
	if !Constants.PHOTOSENSITIVE_MODE:
		cover_animator.play("reveal")
		return 0.6
	else:
		cover_animator.play("reveal (slow)")
		return 1.4
	return 1.0

onready var cover_animator = $CoverAnimator
