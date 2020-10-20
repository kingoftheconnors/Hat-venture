extends CanvasLayer

onready var gui = $Player
onready var energy = $Player/Energy
onready var bossEnergy = $Player/BossArea/BossEnergy
onready var playerScore = $Player/ScoreArea/Score

onready var stageName = $Player/StageName
onready var lives = $Player/LiveNum
onready var pons = $Player/PonsNum

onready var scoreArea = $Player/ScoreArea
onready var bossArea = $Player/BossArea

signal textbox_end

const MAX_ENERGY = 4

func hide():
	gui.visible = false
func show():
	gui.visible = true

func start(stageNum):
	stageName.text = "LV." + str(stageNum)
	energy.value = 4

func update_health(value, max_value):
	energy.set_max(max_value)
	energy.set_value(value)
func heal():
	energy.value = energy.value + 1

func reset_energy():
	energy.value = MAX_ENERGY
func set_lives(num_lives):
	lives.text = str(num_lives)

func set_pons(amo):
	pons.text = str(amo)

func startBossBattle(life):
	bossEnergy.value = life
	# TODO: Show boss health

func set_score(amo):
	playerScore.set_text("SCORE:" + ("%06d" % amo))

onready var dialog = $DialogBox
onready var dialogName = $DialogBox/Name
onready var dialogText = $DialogBox/Dialog

const letters_per_sec = 20.0
var text_to_run = []
var text_crawl_func

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and Constants.DEBUG_MODE:
		queue_dialog([
			{name = "You", text = "The future is now, thanks to dialog!"},
			{name = "Me", text = "Dialog is so amazing!"},
			{name = "You", text = "Indeed! Check out this SCIENCE!!"}
		])
	if text_crawl_func is GDScriptFunctionState:
		text_crawl_func = text_crawl_func.resume(delta)
	elif text_to_run.size() > 0:
		var next_box = text_to_run.pop_front()
		start_dialog(next_box.name, next_box.text)
	elif dialog.visible == true:
		end_dialog()

func queue_dialog(array_text):
	text_to_run += array_text
	if !(text_crawl_func is GDScriptFunctionState):
		var next_box = text_to_run.pop_front()
		start_dialog(next_box.name, next_box.text)

func start_dialog(name, text):
	get_tree().paused = true
	gui.visible = false
	dialog.visible = true
	dialogName.text = name
	dialogText.text = text
	# Start text crawl
	text_crawl_func = crawl(text.length())
	
func end_dialog():
	get_tree().paused = false
	gui.visible = true
	dialog.visible = false

func crawl(text_length):
	# Text crawl
	dialogText.percent_visible = 0
	var speed = 1
	while dialogText.percent_visible < 1:
		var delta = yield()
		dialogText.percent_visible += delta * speed * letters_per_sec/text_length
		if Input.is_action_just_pressed("ui_A"):
			speed = 5
		elif Input.is_action_just_released("ui_A"):
			speed = 1
		if Input.is_action_just_pressed("ui_B"):
			dialogText.percent_visible = 1
	yield()
	# Wait for user input
	while(!Input.is_action_just_pressed("ui_A") and !Input.is_action_just_pressed("ui_B")):
		yield()
	return
