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
const VISIBILITY_RATE = 0.07

## Signal for making the tilemap invisible
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		tween.stop_all()
		tween.interpolate_property(self, "modulate", self.modulate, Color(1, 1, 1, 0.5), 0.25, Tween.TRANS_CUBIC)
		tween.start()

## Signal for making the tilemap visible
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		tween.stop_all()
		tween.interpolate_property(self, "modulate", self.modulate, Color(1, 1, 1, 1), 0.25, Tween.TRANS_CUBIC)
		tween.start()

onready var tween : Tween = $Tween
