# Save system class. Does not extend any node, but rather is
# instanced anywhere in the program to save settings or game data.
class_name SaveSystem

## Overrides existing settings file with input
func save_settings(settings : Dictionary):
	var save_game = File.new()
	save_game.open("user://settings.save", File.WRITE)
	# Store the save dictionary as a new line in the save file.
	save_game.store_line(to_json(settings))
	save_game.close()

## Gets game settings from local machine
func load_settings() -> Dictionary:
	var load_game = File.new()
	if not load_game.file_exists("user://settings.save"):
		return {}
	# Load the file by line and return dictionary
	load_game.open("user://settings.save", File.READ)
	var settings = parse_json(load_game.get_line())
	load_game.close()
	return settings

## Overrides existing keybinds file with input
func save_keybinds(keybinds : Dictionary):
	var save_game = File.new()
	save_game.open("user://keybinds.save", File.WRITE)
	# Store the save dictionary as a new line in the save file.
	save_game.store_line(to_json(keybinds))
	save_game.close()

## Gets game keybinds from local machine
func load_keybinds() -> Dictionary:
	var load_keybinds = File.new()
	if not load_keybinds.file_exists("user://keybinds.save"):
		return {}
	# Load the file by line and return dictionary
	load_keybinds.open("user://keybinds.save", File.READ)
	var settings = parse_json(load_keybinds.get_line())
	load_keybinds.close()
	return settings

## Saves game data, including progress and collectibles
func save_game():
	pass
