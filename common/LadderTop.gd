extends Area2D

## True if this ladder is a top for a ladder beneath the one-way
## floor, and so this script should allow user to climb down down
export(bool) var can_go_down = true
## Floor collider if this is a top-ladder. When climbing down,
## this collider will be disabled
export(NodePath) var top_floor_collider
onready var floor_body = get_node(top_floor_collider)

func climb_down():
	if can_go_down and floor_body:
		floor_body.disabled = true
	return can_go_down

func _on_Ladder_body_entered(body):
	if body.is_in_group("player"):
		body.on_ladder_top(self)

func _on_Ladder_body_exited(body):
	if body.is_in_group("player"):
		body.off_ladder_top(self)
		# Re-enable floor after player goes past ladder
		if can_go_down and floor_body:
			print("Enabled")
			floor_body.call_deferred("set_disabled", false)
