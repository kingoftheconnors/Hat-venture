# Save system class. Does not extend any node, but rather is
# instanced anywhere in the program to save settings or game data.
class_name SaveSystem

## Overrides existing settings file with input
func save_game(settings : Dictionary):
	var save_game = File.new()
	save_game.open("user://game.save", File.WRITE)
	# Store the save dictionary as a new line in the save file.
	save_game.store_line(to_json(settings))
	save_game.close()

## Gets game settings from local machine
func load_game() -> Dictionary:
	var load_game = File.new()
	if not load_game.file_exists("user://game.save"):
		return {}
	# Load the file by line and return dictionary
	load_game.open("user://game.save", File.READ)
	var settings = parse_json(load_game.get_line())
	load_game.close()
	return settings
