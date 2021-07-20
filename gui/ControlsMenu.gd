extends "res://gui/SubMenu.gd"

func reset_to_keybinds():
	save_system = SaveSystem.new()
	var settings = save_system.load_keybinds()
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
	save_system.save_keybinds(keybinds)

func set_to_defaults():
	# Get keys from option keys in menu
	for key in key_controller.get_children():
		key.reset_to_default()

func _ready():
	reset_to_keybinds()

onready var key_controller = $KeyboardKeys
var save_system : SaveSystem
