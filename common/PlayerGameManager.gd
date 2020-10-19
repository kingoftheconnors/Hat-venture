extends Node

onready var animationPlayer = $AnimationPlayer

var lives = 3

func die():
	# Get current levelname to return to after playing animation
	var levelName = get_tree().get_current_scene().filename
	# Fade to white
	animationPlayer.play("cover")
	yield(get_tree().create_timer(.6), "timeout")
	lives -= 1
	Gui.set_lives(lives)
	# TODO: Game over
	if lives <= 0:
		Gui.hide()
		var _success = get_tree().change_scene("res://levelgameover/gameOver.tscn")
		animationPlayer.play("reveal") # Starts with covering screen
	else:
		# Re-load level
		var _success = get_tree().change_scene(levelName)
		Gui.reset_energy()
		Gui.reset_score()
		#get_tree().change_scene("res://transitionScenes/death.tscn")
		animationPlayer.play("reveal") # Starts with covering screen

func one_up():
	lives += 1
	Gui.set_lives(lives)
