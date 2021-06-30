extends Label

signal option_selected

# Change color to show focus
func _on_focus_entered():
	$Arrow.modulate = Color(1, 1, 1, 1)
func _on_focus_exited():
	$Arrow.modulate = Color(1, 1, 1, 0)

# Handle overridable Left and Right functions (and emit signal)
func _input(event):
	# Change keybind
	if has_focus():
		if event.is_action_pressed("ui_A") or event.is_action_pressed("ui_accept"):
			emit_signal("option_selected", option_value)

# Textbox ID to run if this option is picked
var option_value
