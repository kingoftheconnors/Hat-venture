extends Area2D

export(NodePath) var animation_tree
onready var animator = get_node(animation_tree)

func box_entered():
	animator["parameters/conditions/defend"] = true
	animator["parameters/conditions/not_defend"] = false
func box_exited():
	animator["parameters/conditions/defend"] = false
	animator["parameters/conditions/not_defend"] = true

func _on_DefendBox_body_entered(body):
	if body.is_in_group("player"):
		box_entered()

func _on_DefendBox_body_exited(body):
	if body.is_in_group("player"):
		box_exited()
