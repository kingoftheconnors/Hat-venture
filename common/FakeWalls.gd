# Tilemap enhancer that allows walls to turn invisible when
# collided with.
# REQUIREMENTS: Must be the child of an Area2D with "use as
# collider" set to true, and with all collision masks disabled.
# This allows users to pass through the blocks, and for the area2D
# to get the required signals called and connected
extends TileMap

# Length of transition of the tilemap's transparency
export(float, 0, 1) var visibility_effect_time = 0.5

## Final transparency percent for hidden area
export(float, 0, 1) var residual_transparency = 0

## Signal for making the tilemap invisible
func _on_Area2D_body_entered(body):
	var success = true
	if body.is_in_group("player"):
		success = success and tween.stop_all()
		success = success and tween.interpolate_property(self, "modulate", self.modulate, Color(1, 1, 1, residual_transparency), visibility_effect_time, Tween.TRANS_LINEAR)
		success = success and tween.start()
		# Test that tween succeeded
		if !success:
			print("ERROR: Start tween failed: FakeWalls - _on_Area2D_body_entered")

## Signal for making the tilemap visible
func _on_Area2D_body_exited(body):
	var success = true
	if body.is_in_group("player"):
		success = success and tween.stop_all()
		success = success and tween.interpolate_property(self, "modulate", self.modulate, Color(1, 1, 1, 1), visibility_effect_time, Tween.TRANS_LINEAR)
		success = success and tween.start()
		# Test that tween succeeded
		if !success:
			print("ERROR: Start tween failed: FakeWalls - _on_Area2D_body_exited")

onready var tween : Tween = $Tween


func _on_Area2D_area_entered(area):
	pass # Replace with function body.
