extends Area2D

export(game_dialog.DIALOG_TYPE) var dialog_num
export(Array, NodePath) var active_bodies_in_dialog
export(bool) var one_shot

# Signals called by dialog system.
# Connect using the Node tab while inspecting a dialogStarter node
# 
# Methods: you can connect using:
# animate(string) set the object to animate using an animation
#		in its animationTree
# damage(bool) damage it. True for a stomp-style damage, and false
#		for a blast-style
signal action1
signal action2
signal action3

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		for body in get_overlapping_bodies():
			if body.is_in_group("player") and body.is_active():
				# Setup bodies that should move in this dialog
				var active_bodies := [body]
				for path in active_bodies_in_dialog:
					active_bodies.append(get_node(path))
				# Add command to unfreeze active bodies in dialog
				Gui.queue_text(self, {"unfreeze": active_bodies})
				Gui.queue_text(self, {"freeze_player": body})
				# Queue dialog
				Gui.queue_dialog(self, dialog_num)
				# Re-freeze bodies so next dialog won't have them doing whatevs
				Gui.queue_text(self, {"unfreeze_player": body})
				Gui.queue_text(self, {"freeze": active_bodies})
				if one_shot:
					queue_free()
