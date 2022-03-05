extends Control

signal option_selected

# Change color to show focus
func _on_focus_entered():
	$Arrow.modulate = Color(1, 1, 1, 1)
func _on_focus_exited():
	$Arrow.modulate = Color(1, 1, 1, 0)

func _on_pressed():
	emit_signal("option_selected", option_value)

# Textbox ID to run if this option is picked
var option_value
