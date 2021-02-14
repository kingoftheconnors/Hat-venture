# Script for using and saving changes to the options menu
extends NinePatchRect

func _unhandled_input(event):
	# Open and close menu
	if visible:
		if event.is_action_pressed("ui_menu"):
			# Close menu
			close(false)
		if event.is_action_pressed("ui_B"):
			close(true)

func open():
	# Open menu
	show()
	$KeyboardKeys/ui_up.grab_focus()

func close(refocus = false):
	hide()
	if refocus:
		print("Reseting focus")
		settings_menu.reset_focus("controls")

## Save all keybind settings
func save():
	# Get keys from option keys in menu
	var keybinds = {}
	for controller in key_controllers:
		for key in controller.get_children():
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

func set_dirty():
	dirty = true

var save_system : SaveSystem
var dirty = false

func _ready():
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
				var key_node = key_controllers[i].get_node(action)
				key_node.set_key(settings[action][i])

onready var key_controllers : Array = [$KeyboardKeys]
onready var settings_menu = $"../NinePatchRect"
