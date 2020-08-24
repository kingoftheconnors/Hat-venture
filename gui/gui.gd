extends CanvasLayer

onready var gui = $Player
onready var energy = $Player/Energy
onready var bossEnergy = $Player/BossArea/BossEnergy
onready var playerScore = $Player/ScoreArea/Score

onready var stageName = $Player/StageName
onready var lives = $Player/LiveNum

onready var scoreArea = $Player/ScoreArea
onready var bossArea = $Player/BossArea

signal textbox_end

var score = 0

func start(stageNum):
	stageName.text = "stage" + stageNum
	energy.value = 4

func damage():
	energy.value = energy.value - 1

func death():
	energy.value = 0
	lives.text = int(lives.text) - 1

func startBossBattle(life):
	bossEnergy.value = life

func addScore(amo):
	score += amo
	playerScore.text = "SCORE:" + ("%06d" % score)

onready var dialog = $DialogBox
onready var dialogName = $DialogBox/Name
onready var dialogText = $DialogBox/Dialog

const letters_per_sec = 20.0
var text_to_run = []
var text_crawl_func

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
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
	else:
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
