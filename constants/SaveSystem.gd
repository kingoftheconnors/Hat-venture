class_name SaveSystem

func save_settings(settings):
	var save_game = File.new()
	save_game.open("user://settings.save", File.WRITE)
	# Store the save dictionary as a new line in the save file.
	save_game.store_line(to_json(settings))
	save_game.close()
	
func load_settings() -> Dictionary:
	var save_game = File.new()
	if not save_game.file_exists("user://settings.save"):
		return {}
	# Load the file by line and return dictionary
	save_game.open("user://settings.save", File.READ)
	var settings = parse_json(save_game.get_line())
	save_game.close()
	return settings

func save_game():
	pass
