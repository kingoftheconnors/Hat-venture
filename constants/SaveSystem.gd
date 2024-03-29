# Save system class. Does not extend any node, but rather is
# instanced anywhere in the program to save settings or game data.
extends Node2D

# Accessor to lazy initialize datas
func access_data() -> Node2D:
	return self

## Saves game data, including progress and collectibles
func save_game():
	if save_num >= 0:
		var save_game = File.new()
		save_game.open("user://save" + str(save_num) + ".save", File.WRITE)
		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(game_data))
		save_game.close()
	else:
		print("ERROR: No game is currently loaded!")

func load_game(load_save_num : int):
	save_num = load_save_num
	var load_game_data = File.new()
	if not load_game_data.file_exists("user://save" + str(load_save_num) + ".save"):
		return {}
	# Load the file by line and return dictionary
	load_game_data.open("user://save" + str(load_save_num) + ".save", File.READ)
	game_data = parse_json(load_game_data.get_line())
	load_game_data.close()
	return game_data

func set_tag(tag_name, tag_value):
	if !game_data.has("tags"):
		game_data['tags'] = {}
	game_data['tags'][tag_name] = tag_value
	save_game()

func get_tag(tag_name):
	if game_data.has("tags"):
		if game_data['tags'].has(tag_name):
			return game_data['tags'][tag_name]
	return null

func reset_tags():
	game_data['tags'] = {}

func set_pons(pons_num : int):
	game_data['pons'] = pons_num
func get_pons():
	if game_data.has("pons"):
		return game_data['pons']
	return 0


# 'palette_list' should be defined manually. String of palettes.
const default_palettes : Array = [
	"Classic",
	"New Venture"
]

func unlock_palette(new_palette):
	if !game_data.has("palettes"):
		game_data['palettes'] = default_palettes
	game_data['palettes'].append(new_palette)
	save_game()

func is_palette_unlocked(palette_name):
	if game_data.has('palettes'):
		return game_data['palettes'].has(palette_name)
	else:
		return false

func get_palettes() -> Array:
	if game_data.has('palettes') and game_data['palettes'].size() != 0:
		return game_data['palettes']
	else:
		return default_palettes

enum STORYBOOK_PAGES {
	KIRK_1,
	KIRK_2,
	KIRK_3,
	KIRK_4,
	KIRK_5
}

func add_storybook_page(page_num : int):
	if !game_data.has("storybook_pages"):
		game_data['storybook_pages'] = []
	if !game_data['storybook_pages'].has(page_num):
		game_data['storybook_pages'].append(page_num)
	save_game()

var game_data : Dictionary = {}
var save_num : int = -1
