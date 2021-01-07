# Tilemap enhancer that allows walls to turn invisible when
# collided with.
# REQUIREMENTS: Must be the child of an Area2D with "use as
# collider" set to true, and with all collision masks disabled.
# This allows users to pass through the blocks, and for the area2D
# to get the required signals called and connected
extends TileMap

# Final value of the process's tween
var goal_opacity = 1
# Rate of change of the tilemap's transparency
const VISIBILITY_RATE = 0.075

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if modulate.a != goal_opacity:
		if abs(modulate.a - goal_opacity) < .1:
			modulate.a = goal_opacity
		else:
			modulate.a = lerp(modulate.a, goal_opacity, VISIBILITY_RATE)

## Signal for making the tilemap invisible
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		goal_opacity = 0

## Signal for making the tilemap visible
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		goal_opacity = 1
