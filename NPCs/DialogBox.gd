# Dialog Starter functionality for talking with NPCs
# and scenery in-game. When the Area2D this is attached to
# is intersecting with the player and the player presses "up"
# the dialog will be queued in the GUI.
extends Area2D

var active = true

func _process(_delta):
	if Input.is_action_just_pressed("ui_up") and active:
		var started = play_dialog()
		if started:
			active = false
			yield(get_tree().create_timer(2), "timeout")
			active = true

func play_dialog():
	for body in get_overlapping_bodies():
		if body.is_in_group("player") and body.is_active() and dialog_starter.enabled:
			dialog_starter.queue_dialog(body)
			return true

func _on_DialogBox_body_entered(body):
	if body.is_in_group("player") and dialog_starter.enabled:
		up_prompt.visible = true

func _on_DialogBox_body_exited(body):
	if body.is_in_group("player"):
		up_prompt.visible = false

onready var up_prompt = $UpPrompt
onready var dialog_starter = get_parent()
