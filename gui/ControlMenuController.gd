extends Control

signal changed

# Change color to show focus
func _on_focus_entered():
	l_arrow.visible = true
func _on_focus_exited():
	l_arrow.visible = false

# Handle overridable Left and Right functions (and emit signal)
func _input(event):
	# Open and close menu
	if has_focus():
		if event.is_action_pressed("ui_A") or event.is_action_pressed("ui_accept"):
			open_menu()

func open_menu():
	controls_menu.open()

onready var l_arrow : Label = $L
onready var controls_menu = $"../../ControlsMenu"
onready var settings_menu = $".."
