extends Node

onready var animationPlayer = $AnimationPlayer

var lives = 3
var pons = 0
var score = 0
var multiplicity = 1

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
	unpause()
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
	unpause()
	pons = 0; Gui.set_pons(pons)
	score = 0; Gui.set_score(score)
	lives = 4; Gui.set_lives(lives)
	Gui.reset_energy()
	Gui.show()
	# Load level
	var _success = get_tree().change_scene(levelName)
	animationPlayer.play("reveal")

func add_score(amo, affects_multiplicity = false):
	score += amo*multiplicity
	Gui.set_score(score)
	if affects_multiplicity:
		multiplicity += 1
		Gui.set_score_mult(multiplicity)

func reset_multiplicity():
	multiplicity = 1
	Gui.set_score_mult(multiplicity)

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

var active_bodies = []
func pause_except(active_bodies_in_pause):
	for body in active_bodies_in_pause:
		body.set_pause_mode(PAUSE_MODE_PROCESS)
	active_bodies = active_bodies_in_pause
	get_tree().paused = true

func unpause():
	for body in active_bodies:
		if is_instance_valid(body):
			body.set_pause_mode(PAUSE_MODE_INHERIT)
	get_tree().paused = false
