extends Label

signal changed

# Change color to show focus
func _on_focus_entered():
	arrow.visible = true
func _on_focus_exited():
	arrow.visible = false

# Handle overridable Left and Right functions (and emit signal)
func _input(event):
	# Change keybind
	if has_focus():
		if accepting_input and event.is_action_type() and !event.is_echo() and event.is_pressed():
			# TODO: Check that key does not already exist in Inputmap
			set_key(event.as_text())
			accepting_input = false
			accept_event()
		elif event.is_action_pressed("ui_A") or event.is_action_pressed("ui_accept"):
			accepting_input = true
			update_text("_")
			accept_event()

func set_key(key : String):
	cur_key = key
	update_text(key)

func update_text(key : String):
	text = (" %s:%s" % [keyname, key])

func get_cur_key():
	return cur_key

export(String) var keyname = "Up"
export(String) var keybind = "ui_up"
export(String) var cur_key = "Up"
var accepting_input = false
onready var arrow : Label = $Arrow
