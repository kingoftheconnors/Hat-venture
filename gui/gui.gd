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
	scoreArea.visible = true
	bossArea.visible = false

# Health
func update_health(value, max_value):
	energy.set_max(max_value)
	energy.set_value(value)
func heal():
	energy.value = energy.value + 1
func reset_energy():
	energy.value = MAX_ENERGY

# Boss health
func update_boss_health(value, max_value):
	bossEnergy.set_max(max_value)
	bossEnergy.set_value(value)

# Pons
func set_pons(amo):
	pons.text = str(amo)

# Score
var multVisible = false
func set_score(amo):
	playerScore.set_text("%07d" % amo)
func set_score_mult(amo):
	playerScoreMultAmo = amo
	if playerScoreMultAmo == 1:
		multVisible = false
	else:
		multVisible = true
	render_score_mult()
func render_score_mult():
	if multVisible:
		playerScoreLabel.set_text("SCOREx%-2d:" % playerScoreMultAmo)
	else:
		playerScoreLabel.set_text("SCORE   :")

func set_gui_size(size):
	sizeAnimator.play(size)

onready var gui = $Player
onready var energy = $Player/MContainer/GuiInfo/Main/HatKid/Energy
onready var bossAnimator = $Player/MContainer/GuiInfo/Main/Boss/AnimationPlayer
onready var bossEnergy = $Player/MContainer/GuiInfo/Main/Boss/BossEnergy
onready var playerScoreLabel = $Player/MContainer/GuiInfo/Main/Score/Score
onready var playerScore = $Player/MContainer/GuiInfo/Main/Score/ScoreNum
var playerScoreMultAmo = 1

onready var sizeAnimator = $AnimationPlayer

onready var stageName = $Player/MContainer/GuiInfo/Pons/StageName
onready var pons = $Player/MContainer/GuiInfo/Pons/HBoxContainer/PonsNum

onready var scoreArea = $Player/MContainer/GuiInfo/Main/Score
onready var bossArea = $Player/MContainer/GuiInfo/Main/Boss

### ------------------------------
### DIALOG
### -------------------------------

const letters_per_sec = 20.0
var text_to_run = []
var text_crawl_func
var dialog_active = false
var cur_speaking_name = ""
const LINE_LENGTH = 30
const DIALOG_AUTOSCROLL_NEXTBOX_DELAY : float = 1.0

func _process(delta):
	if !menu_exists:
		if text_crawl_func is GDScriptFunctionState:
			# Pre-empt textboxes
			text_crawl_func = text_crawl_func.resume(delta)
		elif text_to_run.size() > 0:
			var next_box = text_to_run.pop_front()
			start_dialog(next_box)
		elif dialog_active:
			end_dialog()
	if get_tree().paused and playerScoreMultAmo > 1:
		multVisible = true
		render_score_mult()

var menu_exists: bool = false
var can_skip_cutscene : bool = true
func _unhandled_input(event):
	if event.is_action_pressed("toggle_hud"):
		gui.visible = !gui.visible
	# Open and close menu
	if event.is_action_pressed("ui_menu"):
		if menu_exists == false:
			if dialog_active:
				if can_skip_cutscene:
					# skip cutscene menu
					var iOptionsMenu = preload("res://gui/optionsmenu/SkipCutsceneMenu.tscn").instance()
					get_node("/root/Gui").add_child(iOptionsMenu)
					iOptionsMenu.connect("skip_cutscene", self, "skip_cutscene")
					iOptionsMenu.open()
					menu_exists = true
			else:
				if !get_tree().paused:
					var iOptionsMenu = preload("res://gui/optionsmenu/SettingsMenu.tscn").instance()
					get_node("/root/Gui").add_child(iOptionsMenu)
					iOptionsMenu.open()
					menu_exists = true
			
			if menu_exists:
				# Move palette_filter to bottom of scene list so it's OVER the menu
				var palette = get_node("/root/Gui/PaletteFilter")
				get_node("/root/Gui").remove_child(palette)
				get_node("/root/Gui").add_child(palette)
				get_tree().set_input_as_handled()

func menu_opened() -> void:
	menu_exists = true
func menu_closed() -> void:
	menu_exists = false

func queue_text(dialog_starter, textbox : Dictionary):
	queue(dialog_starter, [textbox])

func queue_dialog(dialog_starter, textbox_num : int):
	var textbox = textboxes.get_dialog(textbox_num)
	queue(dialog_starter, textbox)

func queue_dialog_at_front(dialog_starter, textbox_num : int):
	var textbox = textboxes.get_dialog(textbox_num)
	for textbox_dict in textbox:
		textbox_dict.starter = dialog_starter
	text_to_run = textbox + text_to_run

func queue(dialog_starter, textbox):
	for textbox_dict in textbox:
		textbox_dict.starter = dialog_starter
	text_to_run += textbox
	if !(text_crawl_func is GDScriptFunctionState):
		var next_box = text_to_run.pop_front()
		start_dialog(next_box)

func start_dialog(next_box, skip_events : int = Constants.SKIP_CUTSCENES):
	dialog_active = true
	PlayerGameManager.pause_except([])
	
	if next_box.has("if_tag_false") \
		and SaveSystem.access_data().get_tag(next_box['if_tag_false']) != null \
		and SaveSystem.access_data().get_tag(next_box['if_tag_false']) != false:
		return
	if next_box.has("if_tag_true") \
		and SaveSystem.access_data().get_tag(next_box['if_tag_true']) != true:
		return
	
	cur_speaking_name = ""
	if next_box.has("name"):
		if skip_events == Constants.SKIP_TYPE.RUN or next_box.has("unskippable"):
			gui.visible = false
			dialog.visible = true
			dialogName.text = next_box.name
			cur_speaking_name = next_box.name
			dialogText.bbcode_text = next_box.text
			dialogText.visible_characters = 0
			# Start text crawl
			text_crawl_func = crawl(next_box)
		elif next_box.has("options"):
			var first_option = next_box.options.keys()[0]
			var next_textbox_num = next_box.options[first_option]
			queue_dialog_at_front(next_box.starter, next_textbox_num)
	elif next_box.has("signal"):
		if skip_events == Constants.SKIP_TYPE.RUN or skip_events == Constants.SKIP_TYPE.WORDLESS or next_box.has("unskippable"):
			next_box.starter.emit_signal(next_box.signal)
	elif next_box.has("animate1"):
		if skip_events == Constants.SKIP_TYPE.RUN or skip_events == Constants.SKIP_TYPE.WORDLESS or next_box.has("unskippable"):
			next_box.starter.animate1(next_box.animate1)
	elif next_box.has("animate2"):
		if skip_events == Constants.SKIP_TYPE.RUN or skip_events == Constants.SKIP_TYPE.WORDLESS or next_box.has("unskippable"):
			next_box.starter.animate2(next_box.animate2)
	elif next_box.has("settag"):
		SaveSystem.access_data().set_tag(next_box['settag'], next_box['value'])
	elif next_box.has("queue"):
		queue_dialog_at_front(next_box.starter, next_box['queue'])
	elif next_box.has("delaytil_animate1_method_true"):
		if skip_events == Constants.SKIP_TYPE.RUN or skip_events == Constants.SKIP_TYPE.WORDLESS or next_box.has("unskippable"):
			text_crawl_func = wait_for_method_true(next_box.starter, "animate1_method_true", next_box['delaytil_animate1_method_true'])
	elif next_box.has("delaytil_animate2_method_true"):
		if skip_events == Constants.SKIP_TYPE.RUN or skip_events == Constants.SKIP_TYPE.WORDLESS or next_box.has("unskippable"):
			text_crawl_func = wait_for_method_true(next_box.starter, "animate2_method_true", next_box['delaytil_animate2_method_true'])
	elif next_box.has("enable"):
		for body in next_box['enable']:
			if is_instance_valid(body):
				body.set_pause_mode(PAUSE_MODE_PROCESS)
	elif next_box.has("disable"):
		for body in next_box['disable']:
			if is_instance_valid(body):
				body.set_pause_mode(PAUSE_MODE_INHERIT)
	elif next_box.has("enable_skipping"):
		can_skip_cutscene = true
	elif next_box.has("disable_skipping"):
		can_skip_cutscene = false
	elif next_box.has("unfreeze_player"):
		if is_instance_valid(next_box['unfreeze_player']):
			next_box['unfreeze_player'].set_freeze(false)
	elif next_box.has("freeze_player"):
		if is_instance_valid(next_box['freeze_player']):
			next_box['freeze_player'].set_freeze(true)
	elif next_box.has("brightness"):
		set_brightness_param(next_box['brightness'])
	elif next_box.has("level"):
		var spawn_point = -1
		if next_box.has('spawn_point'):
			spawn_point = next_box['spawn_point']
		PlayerGameManager.level_complete()
		PlayerGameManager.start_level(next_box['level'], spawn_point)
	elif next_box.has("fadeout"):
		Gui.cover()
	elif next_box.has("fadein"):
		Gui.reveal()
	elif next_box.has("sound"):
		SoundSystem.start_sound(next_box['sound'])
	elif next_box.has("music"):
		SoundSystem.start_music(next_box['music'])
	elif next_box.has("fadeout_music"):
		SoundSystem.fadeout_music()
	elif next_box.has("fadeout_music_fast"):
		SoundSystem.fadeout_music_fast()
	elif next_box.has("addpon"):
		PlayerGameManager.add_pons(next_box["addpon"])
	elif next_box.has("queue_free"):
		if is_instance_valid(next_box['queue_free']) and next_box['queue_free'] != null:
			next_box['queue_free'].queue_free()
	
	# Wait for program to return signal that we can continue scene
	if next_box.has("delay"):
		if skip_events == Constants.SKIP_TYPE.RUN or skip_events == Constants.SKIP_TYPE.WORDLESS or next_box.has("unskippable"):
			if dialog.visible:
				gui.visible = true
				dialog.visible = false
			text_crawl_func = delay(next_box['delay'])

func play_boss_health_get_sfx():
	SoundSystem.start_sound(SoundSystem.SFX.BOSS_LIFE_GET)

func skip_cutscene():
	text_crawl_func = null
	if curbox != null and curbox.has('options'):
		var first_option = curbox.options.keys()[0]
		var next_textbox_num = curbox.options[first_option]
		queue_dialog_at_front(curbox.starter, next_textbox_num)
	while text_to_run.size() > 0:
		var next_box = text_to_run.pop_front()
		start_dialog(next_box, true)
		if next_box.has('level'):
			return

func end_dialog():
	dialog_active = false
	PlayerGameManager.unpause()
	if dialog.visible:
		gui.visible = true
		dialog.visible = false
	emit_signal("textbox_end")

func delay(wait_time):
	var time_passed = 0
	while time_passed < wait_time:
		var delta = yield()
		time_passed += delta

var curbox = null
func crawl(text_box):
	curbox = text_box
	# Text crawl
	var letters_visible : float = 0
	var cur_line = 0
	var speed = 1
	while letters_visible < dialogText.text.length():
		var delta = yield()
		letters_visible += delta * speed * letters_per_sec
		dialogText.set_visible_characters(int(letters_visible))
		if dialogText.get_visible_line_count() > cur_line + 2:
			# Wait for user input
			if text_box.has("autoscroll") and text_box.autoscroll:
				var time_passed = 0
				while time_passed < DIALOG_AUTOSCROLL_NEXTBOX_DELAY:
					time_passed += yield()
			else:
				advanceButton.show()
				while(!Input.is_action_just_pressed("ui_accept") and !Input.is_action_just_pressed("ui_B")):
					yield()
				advanceButton.hide()
			cur_line += 2
			dialogText.scroll_to_line(cur_line)
		elif (!text_box.has("autoscroll") or !text_box.autoscroll) and (Input.is_action_just_pressed("ui_accept")):
			# Set letters to fill if the user pressed A
			# or if they pressed B and the textbox has options
			while(dialogText.get_visible_line_count() < cur_line + 2 and letters_visible < dialogText.text.length()):
				letters_visible += 1
				dialogText.set_visible_characters(int(letters_visible))
		elif (!text_box.has("autoscroll") or !text_box.autoscroll) and Input.is_action_just_pressed("ui_B") and !text_box.has("options"):
			# Check if this is the last textbox.
			# If it is, add delay so player won't activate powers on accident
			var text_queue_finished = true
			for textbox in text_to_run:
				if !textbox.has("freeze_player") and !textbox.has("unfreeze_player") \
					and !textbox.has("enable") and !textbox.has("disable"):
					text_queue_finished = false
			if text_queue_finished:
				text_to_run.push_front({delay=0.25})
			return
	yield()
	if text_box.has("options"):
		if dialogText.get_line_count() > 1:
			cur_line += 1
			dialogText.scroll_to_line(cur_line)
		dialogOptions.show_options(text_box.options)
		var selected_option = -1
		while selected_option < 0:
			selected_option = dialogOptions.poll_user_selection()
			yield()
		dialogOptions.hide_options()
		queue_dialog_at_front(text_box.starter, selected_option)
	else:
		# Wait for user input
		if text_box.has("autoscroll") and text_box.autoscroll:
			var time_passed = 0
			while time_passed < DIALOG_AUTOSCROLL_NEXTBOX_DELAY:
				time_passed += yield()
		else:
			advanceButton.show()
			while(!Input.is_action_just_pressed("ui_accept") and !Input.is_action_just_pressed("ui_B")):
				yield()
			advanceButton.hide()
	return

func wait_for_method_true(object : Node, function_name : String, param):
	while object.call(function_name, param) == false:
		yield()

## Sets score multiplicity to visible or invisible
## based on the amount of time left. Visualizes the speed at
## which multiplicity time is depleting
func notify_multiplicity_time(time):
	if time < 0.1:
		multVisible = true
		render_score_mult()
	elif time < 0.25:
		multVisible = false
		render_score_mult()
	elif time < 0.4:
		multVisible = true
		render_score_mult()
	elif time < 0.55:
		multVisible = false
		render_score_mult()
	elif time < 0.7:
		multVisible = true
		render_score_mult()
	elif time < 0.85:
		multVisible = false
		render_score_mult()

onready var dialog = $DialogBox
onready var dialogName = $DialogBox/Name
onready var dialogText = $DialogBox/Dialog
onready var dialogOptions = $DialogBox/DialogOptions
onready var advanceButton = $DialogBox/AdvanceButton
onready var textboxes = game_dialog.new()

### ------------------------------
### Boss
### -------------------------------

func boss_start(health):
	bossArea.visible = true
	scoreArea.visible = false
	bossAnimator.play("FillEnergy")

### ------------------------------
### Screen Resolution
### -------------------------------

var cur_resolution : Vector2 = Vector2.ZERO
var cur_multiplier : int = 1
func set_screen_resolution(new_size : Vector2) -> void:
	cur_resolution = new_size
	ProjectSettings.set_setting("display/window/integer_resolution_handler/base_width", new_size.x)
	ProjectSettings.set_setting("display/window/integer_resolution_handler/base_height", new_size.y)
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP_HEIGHT, new_size)
	OS.set_window_size(cur_resolution * cur_multiplier)
	OS.center_window()

func set_screen_multiplier(mult: int) -> void:
	cur_multiplier = mult
	OS.set_window_size(cur_resolution * cur_multiplier)
	OS.center_window()

func get_screen_resolution() -> Vector2:
	return cur_resolution

### ------------------------------
### Palette
### -------------------------------

onready var paletteManager = $PaletteFilter
func set_palette(palette_name):
	paletteManager.set_palette(palette_name)
func set_brightness(val):
	paletteManager.set_brightness(val)
func set_brightness_param(val):
	paletteManager.set_brightness_param(val)
func is_player_colors_different() -> bool:
	return paletteManager.is_player_colors_different()
func get_palette():
	# Move palette_filter to bottom of scene list so it's OVER the menu
	return paletteManager.get_palette()

### ------------------------------
### Parallax
### -------------------------------

func cover() -> float:
	if Constants.PHOTOSENSITIVE_MODE:
		cover_animator.play("cover (slow)")
		return 1.3
	else:
		cover_animator.play("cover")
		return .45
func reveal() -> float:
	if Constants.PHOTOSENSITIVE_MODE:
		cover_animator.play("reveal (slow)")
		return 1.3
	else:
		cover_animator.play("reveal")
		return .45
func unlock_palette(palette_name, enter_from : int):
	$UnlockPaletteBox.visible = true
	$UnlockPaletteBox.grab_focus()
	$UnlockPaletteBox.show_palette_get(palette_name, enter_from)
	SaveSystem.access_data().unlock_palette(palette_name)
func unlock_storybook_page(num_pages : int, enter_from : int):
	$UnlockPaletteBox.visible = true
	$UnlockPaletteBox.grab_focus()
	$UnlockPaletteBox.show_storybook_get(num_pages, enter_from)


onready var cover_animator = $CoverAnimator
