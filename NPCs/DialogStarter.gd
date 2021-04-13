# Dialog Starter functionality for talking with NPCs
# and scenery in-game. When the Area2D this is attached to
# is intersecting with the player and the player presses "up"
# the dialog will be queued in the GUI.
extends Area2D

## Dialog text box number from the gui/game_dialog file
export(game_dialog.DIALOG_TYPE) var dialog_num
## Array of bodies that should remain mobile during dialog
export(Array, NodePath) var active_bodies_in_dialog
## If true, this dialog will only happen once before destroying itself
export(bool) var one_shot

## Signals called by dialog system.
## Connect using the Node tab while inspecting a dialogStarter node
## Can call any method on any other node in the scene
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
signal action1; signal action2; signal action3


func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		for body in get_overlapping_bodies():
			if body.is_in_group("player") and body.is_active():
				# Setup bodies that should move in this dialog
				var active_bodies := [body]
				for path in active_bodies_in_dialog:
					active_bodies.append(get_node(path))
				# Add command to unfreeze active bodies in dialog
				Gui.queue_text(self, {"enable": active_bodies})
				Gui.queue_text(self, {"freeze_player": body})
				# Queue dialog
				Gui.queue_dialog(self, dialog_num)
				# Re-freeze bodies so next dialog won't have them doing whatevs
				Gui.queue_text(self, {"unfreeze_player": body})
				Gui.queue_text(self, {"disable": active_bodies})
				if one_shot:
					queue_free()


func _on_DialogBox_body_entered(body):
	if body.is_in_group("player"):
		up_prompt.visible = true

func _on_DialogBox_body_exited(body):
	if body.is_in_group("player"):
		up_prompt.visible = false

onready var up_prompt = $UpPrompt
