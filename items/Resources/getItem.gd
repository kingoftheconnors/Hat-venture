extends Node2D

export(Resource) var itemCommand

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		collect(body)

func collect(body):
	var destroy = itemCommand.new().power(body, self)
	if destroy:
		queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		var parent = area.get_parent()
		while parent.get_name() != "Player":
			parent = parent.get_parent()
		collect(parent)
