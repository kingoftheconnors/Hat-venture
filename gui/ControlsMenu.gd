# Script for using and saving changes to the options menu
extends NinePatchRect

func _unhandled_input(event):
	# Open and close menu
	if visible:
		if event.is_action_pressed("ui_menu") or event.is_action_pressed("ui_B"):
			# Close menu
			close()
			get_tree().set_input_as_handled() 

func open():
	# Open menu
	show()
	reset_to_keybinds()
	$KeyboardKeys/ui_up.grab_focus()

func close():
	hide()
	settings_menu.reset_focus("controls")

## Save all keybind settings
func save():
	# Get keys from option keys in menu
	var keybinds = {}
	for key in key_controller.get_children():
		if keybinds.has(key.keybind):
			keybinds[key.keybind].append(key.get_cur_key())
		else:
			keybinds[key.keybind] = [key.get_cur_key()]
		# Apply found keybinds to inputmap
		InputMap.action_erase_events(key.keybind)
		var keybindEvent = InputEventKey.new()
		keybindEvent.scancode = OS.find_scancode_from_string(key.get_cur_key())
		InputMap.action_add_event(key.keybind, keybindEvent)
	SaveSystem.save_keybinds(keybinds)

func get_keyname(keyname) -> String:
	for key in key_controller.get_children():
		if key.keybind == keyname:
			return key.get_cur_key()
	return ""

func set_to_defaults():
	# Get keys from option keys in menu
	for key in key_controller.get_children():
		key.reset_to_default()
	save()

func reset_to_keybinds():
	var settings = SaveSystem.load_keybinds()
	for action in InputMap.get_actions():
		if settings.has(action):
			InputMap.action_erase_events(action)
			# Add all input keys to InputMap
			for i in range(settings[action].size()):
				var keybindEvent = InputEventKey.new()
				keybindEvent.scancode = OS.find_scancode_from_string(settings[action][i])
				InputMap.action_add_event(action, keybindEvent)
				# Change text of KeyboardKeys
				var key_node = key_controller.get_node(action)
				key_node.set_key(settings[action][i])


func set_dirty():
	dirty = true

var dirty = false

func _ready():
	reset_to_keybinds()

onready var key_controller = $KeyboardKeys
onready var settings_menu = $"../NinePatchRect"
