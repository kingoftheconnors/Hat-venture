extends Label

# Change color to show focus
func _on_focus_entered():
	cursor.visible = true
func _on_focus_exited():
	cursor.visible = false

# Handle overridable Left and Right functions (and emit signal)
func _unhandled_input(event):
	# Change keybind
	if has_focus() and event.is_action_pressed("ui_accept"):
		PlayerGameManager.reset_stats()
		PlayerGameManager.start_level("res://world1/level1.tscn")

onready var cursor : Control = $Selector
export(bool) var default_focus = false
