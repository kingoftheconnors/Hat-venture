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
	photosensitivity_mode = !photosensitivity_mode
	update_text()
	emit_signal("changed")
func move_right():
	photosensitivity_mode = !photosensitivity_mode
	update_text()
	emit_signal("changed")

func update_text():
	current_label.text = "ON" if photosensitivity_mode else "OFF"

func set_photosensitivity_mode(flag : bool):
	photosensitivity_mode = flag
	update_text()
func get_photosensitivity_mode() -> bool:
	return photosensitivity_mode

var photosensitivity_mode : bool = false
onready var l_arrow : Label = $L
onready var r_arrow : Label = $R
onready var current_label : Label = $Current
