extends Area2D

export(game_dialog.DIALOG_TYPE) var dialog_num

signal action1
signal action2

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				Gui.queue_dialog(self, dialog_num)

func continue_scene():
	Gui.continue_scene()
