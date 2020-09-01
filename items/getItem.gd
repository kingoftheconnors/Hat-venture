extends Node2D

export(Resource) var itemCommand

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		itemCommand.power(body, self)
		queue_free()
