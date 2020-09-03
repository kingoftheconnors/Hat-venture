extends Node2D

export(Resource) var itemCommand

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		collect(body)

func collect(body):
	print("Collecting")
	var destroy = itemCommand.new().power(body, self)
	if destroy:
		queue_free()
