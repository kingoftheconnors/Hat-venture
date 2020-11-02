extends Area2D

export(game_dialog.DIALOG_TYPE) var dialog_num

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				Gui.queue_dialog(dialog_num)
