extends Area2D

export(NodePath) var foregroundSprite = "."

onready var foreground = get_node(foregroundSprite)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		foreground.visible = false

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		foreground.visible = true
