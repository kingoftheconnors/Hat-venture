extends TileMap

var goal_opacity = 1
const VISIBILITY_RATE = 0.075

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if abs(modulate.a - goal_opacity) < .1:
		modulate.a = goal_opacity
	else:
		modulate.a = lerp(modulate.a, goal_opacity, VISIBILITY_RATE)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		goal_opacity = 0

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		goal_opacity = 1
