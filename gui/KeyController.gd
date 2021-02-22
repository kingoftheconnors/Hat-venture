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
			# Check that key does not already exist in Inputmap
			for key_node in get_tree().get_nodes_in_group("key"):
				# If this key is already being used, set other option's key to this one
				if key_node != self and key_node.get_cur_key() == event.as_text():
					key_node.set_key(cur_key)
			set_key(event.as_text())
			emit_signal("changed")
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

func reset_to_default():
	set_key(default)

export(String) var keyname = "Up"
export(String) var keybind = "ui_up"
export(String) var cur_key = "Up"
var accepting_input = false
onready var default = cur_key
onready var arrow : Label = $Arrow
