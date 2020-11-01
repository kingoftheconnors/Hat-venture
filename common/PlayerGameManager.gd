extends Node

onready var animationPlayer = $AnimationPlayer

var lives = 3
var pons = 0
var score = 0

func _unhandled_input(event):
	if Constants.DEBUG_MODE:
		if event is InputEventKey and event.pressed and event.scancode == KEY_EQUAL:
			add_score(100)
		if event is InputEventKey and event.pressed and event.scancode == KEY_MINUS:
			score = 0; Gui.set_score(score)
		if event is InputEventKey and event.pressed and event.scancode == KEY_0:
			add_pons(3)

func die():
	# Get current levelname to return to after playing animation
	var levelName = get_tree().get_current_scene().filename
	# Fade to white
	animationPlayer.play("cover")
	yield(get_tree().create_timer(.6), "timeout")
	pons = 0; Gui.set_pons(pons)
	lives -= 1; Gui.set_lives(lives)
	# Game over
	if lives <= 0:
		Gui.hide()
		score = 0; Gui.set_score(score)
		var _success = get_tree().change_scene("res://levelgameover/gameOver.tscn")
		animationPlayer.play("reveal") # Starts with covering screen
	else:
		# Re-load level
		var _success = get_tree().change_scene(levelName)
		Gui.reset_energy()
		#get_tree().change_scene("res://transitionScenes/death.tscn")
		animationPlayer.play("reveal") # Uncover screen after loading level

func start_level(levelNum):
	# Get levelname to return to after playing animation
	var levelName = "res://level" + str(levelNum) + "/level" + str(levelNum) + ".tscn"
	# Fade to white
	animationPlayer.play("cover")
	yield(get_tree().create_timer(.6), "timeout")
	pons = 0; Gui.set_pons(pons)
	score = 0; Gui.set_score(score)
	lives = 4; Gui.set_lives(lives)
	Gui.reset_energy()
	# Load level
	var _success = get_tree().change_scene(levelName)
	animationPlayer.play("reveal")

func add_score(amo):
	score += amo
	Gui.set_score(score)

func add_pons(amo):
	pons = pons + amo
	add_score(amo*25)
	if pons >= 100:
		pons = pons - 100
		PlayerGameManager.one_up()
	Gui.set_pons(pons)

func one_up():
	lives += 1
	Gui.set_lives(lives)
