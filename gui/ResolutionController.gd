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
	resolution_index = wrapi(resolution_index-1, 0, RESOLUTION_SIZES.size())
	update_resolution()
	emit_signal("changed")
func move_right():
	resolution_index = wrapi(resolution_index+1, 0, RESOLUTION_SIZES.size())
	update_resolution()
	emit_signal("changed")

func update_resolution():
	current_label.text = RESOLUTION_SIZES.keys()[resolution_index]
	var new_size : Vector2 = RESOLUTION_SIZES[RESOLUTION_SIZES.keys()[resolution_index]]
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, new_size)
	#Find closest multiple of new resolution near current window size
	var dist_to_cur_size = OS.get_window_size().distance_to(new_size)
	var multiplier : int = 1
	for mult in range(2, 5):
		if OS.get_window_size().distance_to(new_size*mult) < dist_to_cur_size \
			and new_size.x*mult < OS.get_screen_size().x and new_size.y*mult < OS.get_screen_size().y:
			multiplier = mult
	if !OS.window_maximized:
		OS.set_window_size(new_size * multiplier)

func set_cur_resolution(resolution : String):
	var new_resolution_index = RESOLUTION_SIZES.keys().find(resolution)
	if new_resolution_index >= 0:
		resolution_index = new_resolution_index
		update_resolution()
func get_cur_resolution_name() -> String:
	return RESOLUTION_SIZES.keys()[resolution_index]
func get_cur_resolution() -> String:
	return RESOLUTION_SIZES[RESOLUTION_SIZES.keys()[resolution_index]]

func set_to_default():
	resolution_index = 2
	update_resolution()

const RESOLUTION_SIZES : Dictionary = {
	#"160x144": Vector2(160, 144), # Classic gameboy resolution
	#"240x160": Vector2(240, 160),
	"256x192": Vector2(256, 192),
	"256x256": Vector2(256, 256),
	"320x288": Vector2(320, 288)
}
var resolution_index = 2
onready var l_arrow : Label = $L
onready var r_arrow : Label = $R
onready var current_label : Label = $Current
