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
	size_index = wrapi(size_index-1, 0, usable_sizes.size())
	update_gui()
	emit_signal("changed")
func move_right():
	size_index = wrapi(size_index+1, 0, usable_sizes.size())
	update_gui()
	emit_signal("changed")

func update_gui():
	current_label.text = usable_sizes[size_index]
	Gui.set_gui_size(usable_sizes[size_index])
	size_animator.play(usable_sizes[size_index])
	control_menu_size_animator.play(usable_sizes[size_index])

func set_cur_size(size : String):
	var new_size_index = usable_sizes.find(size)
	if new_size_index >= 0:
		size_index = new_size_index
		update_gui()
func get_cur_size():
	return usable_sizes[size_index]

var usable_sizes : Array = ["regular", "medium", "large"]
var size_index = 0
onready var l_arrow : Label = $L
onready var r_arrow : Label = $R
onready var current_label : Label = $Current
onready var size_animator : AnimationPlayer = $"../AnimationPlayer"
onready var control_menu_size_animator : AnimationPlayer = $"../../ControlsMenu/AnimationPlayer"
