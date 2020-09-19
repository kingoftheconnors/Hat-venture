extends Node

onready var animationPlayer = $AnimationPlayer

func die():
	# Get current levelname to return to after playing animation
	var levelName = get_tree().get_current_scene().filename
	animationPlayer.play("cover")
	yield(get_tree().create_timer(.7), "timeout")
	get_tree().change_scene(levelName)
	Gui.death()
	Gui.reset_score()
	Gui.show()
	#get_tree().change_scene("res://transitionScenes/death.tscn")
	animationPlayer.play("reveal") # Starts with covering screen
	yield(get_tree().create_timer(.7), "timeout")
