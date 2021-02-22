extends Label

# Change color to show focus
func _on_focus_entered():
	arrow.visible = true
func _on_focus_exited():
	arrow.visible = false

# Handle overridable Left and Right functions (and emit signal)
func _input(event):
	# Change keybind
	if has_focus():
		if event.is_action_pressed("ui_A") or event.is_action_pressed("ui_accept"):
			print("TODO: Go to main menu!")

onready var arrow : Label = $Arrow
