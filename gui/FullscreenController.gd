extends Control

signal changed

# Change color to show focus
func _on_focus_entered():
	l_arrow.visible = true
	r_arrow.visible = true
func _on_focus_exited():
	l_arrow.visible = false
	r_arrow.visible = false

# Handle overridable Left and Right functions (and emit signal)
func _input(event):
	# Open and close menu
	if has_focus():
		if event.is_action_pressed("ui_left"):
			move_left()
			accept_event()
		if event.is_action_pressed("ui_right"):
			move_right()
			accept_event()

func move_left():
	fullscreen = !fullscreen
	update_resolution()
	emit_signal("changed")
func move_right():
	fullscreen = !fullscreen
	update_resolution()
	emit_signal("changed")

func update_resolution():
	current_label.text = "ON" if fullscreen else "OFF"
	OS.window_fullscreen = fullscreen

func set_fullscreen(flag : bool):
	fullscreen = flag
	update_resolution()
func is_fullscreen():
	return fullscreen

var fullscreen : bool = false
onready var l_arrow : Label = $L
onready var r_arrow : Label = $R
onready var current_label : Label = $Current
