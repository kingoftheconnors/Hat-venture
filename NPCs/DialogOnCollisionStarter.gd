extends Area2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and body.is_active() and dialog_starter.enabled:
		dialog_starter.queue_dialog(body)

onready var dialog_starter = get_parent()
