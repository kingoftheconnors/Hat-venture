extends Button

func show():
	visible = true
	$AnimationPlayer.play("bounce")
	text = OS.get_scancode_string(ggsManager.settings_data["12"].current.value)

func hide():
	visible = false
	$AnimationPlayer.stop()
