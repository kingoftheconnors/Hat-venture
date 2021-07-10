extends Node2D

func show():
	modulate = Color.white
	visible = true

func hide():
	$Tween.stop_all()
	$Tween.interpolate_property(self, "modulate", self.modulate, Color(0, 0, 0, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_all_completed():
	visible = false
