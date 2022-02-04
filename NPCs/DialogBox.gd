# Dialog Starter functionality for talking with NPCs
# and scenery in-game. When the Area2D this is attached to
# is intersecting with the player and the player presses "up"
# the dialog will be queued in the GUI.
extends Area2D

var inactive_timer : float = 0.0

func _process(delta):
	if inactive_timer > 0:
		inactive_timer -= delta
	if Input.is_action_just_pressed("ui_up") and inactive_timer <= 0:
		var started = play_dialog()
		if started:
			inactive_timer = 2

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
