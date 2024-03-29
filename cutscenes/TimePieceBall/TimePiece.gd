extends Sprite

var goal_node : Node2D = null
const SPEED = 200

func set_goal_node(target):
	goal_node = target

func _physics_process(delta):
	if (goal_node != null and is_instance_valid(goal_node)):
		var goal = goal_node.position + Vector2.UP*10
		if position.distance_to(goal) > 10:
			position = position.move_toward(goal, delta*SPEED)
		else:
			position = lerp(position, goal, 0.8)
	if (goal_node != null and not is_instance_valid(goal_node)):
		queue_free()
