extends Label

func _ready():
	visible = Constants.DEBUG_MODE

func _unhandled_input(event):
	if event.is_action_pressed("toggle_debug_mode"):
		Constants.DEBUG_MODE = !Constants.DEBUG_MODE
		visible = Constants.DEBUG_MODE
	if event.is_action_pressed("toggle_hud"):
		visible = !visible
