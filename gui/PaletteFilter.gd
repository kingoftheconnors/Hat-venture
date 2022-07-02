class_name Palettes
extends TextureRect

enum COLOR {
	WORLD_WHITE = 0,
	WORLD_LIGHT = 1,
	WORLD_DARK = 2,
	WORLD_BLACK = 3,
	PLAYER_WHITE = 4,
	PLAYER_LIGHT = 5,
	PLAYER_DARK = 6,
	PLAYER_BLACK = 7,
	ENEMY_WHITE = 8,
	ENEMY_LIGHT = 9,
	ENEMY_DARK = 10,
	ENEMY_BLACK = 11,
	SCENERY_WHITE = 12,
	SCENERY_LIGHT = 13,
	SCENERY_DARK = 14,
	SCENERY_BLACK = 15
}

signal palette_changed
signal brightness_changed

var cur_palette : String = "Classic"
var cur_palette_size = 4
var cur_brightness : int = 0

func set_palette(palette_name : String):
	cur_palette = palette_name
	cur_palette_size = palettes[cur_palette].size()
	update_colors()
	emit_signal("palette_changed")

onready var playerFilter = $PlayerFilter
func is_player_colors_different() -> bool:
	return cur_palette_size > 4
func get_palette():
	return palettes[cur_palette]

func update_colors():
	var spriteFilter = $SpriteFilter
	var backgroundFilter = $BackgroundFilter
	
	var palette : Array = palettes[cur_palette]
	material.set_shader_param("palette_white", palette[COLOR.WORLD_WHITE] + Color(.1, .1, .1)*cur_brightness)
	material.set_shader_param("palette_light", palette[COLOR.WORLD_LIGHT] + Color(.1, .1, .1)*cur_brightness)
	material.set_shader_param("palette_dark", palette[COLOR.WORLD_DARK] + Color(.1, .1, .1)*cur_brightness)
	material.set_shader_param("palette_black", palette[COLOR.WORLD_BLACK] + Color(.1, .1, .1)*cur_brightness)
	if palette.size() > 12:
		playerFilter.material.set_shader_param("palette_white", palette[COLOR.PLAYER_WHITE] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_light", palette[COLOR.PLAYER_LIGHT] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_dark", palette[COLOR.PLAYER_DARK] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_black", palette[COLOR.PLAYER_BLACK] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_white", palette[COLOR.ENEMY_WHITE] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_light", palette[COLOR.ENEMY_LIGHT] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_dark", palette[COLOR.ENEMY_DARK] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_black", palette[COLOR.ENEMY_BLACK] + Color(.1, .1, .1)*cur_brightness)
		backgroundFilter.material.set_shader_param("palette_white", palette[COLOR.SCENERY_WHITE] + Color(.1, .1, .1)*cur_brightness)
		backgroundFilter.material.set_shader_param("palette_light", palette[COLOR.SCENERY_LIGHT] + Color(.1, .1, .1)*cur_brightness)
		backgroundFilter.material.set_shader_param("palette_dark", palette[COLOR.SCENERY_DARK] + Color(.1, .1, .1)*cur_brightness)
		backgroundFilter.material.set_shader_param("palette_black", palette[COLOR.SCENERY_BLACK] + Color(.1, .1, .1)*cur_brightness)
	elif palette.size() > 8:
		playerFilter.material.set_shader_param("palette_white", palette[COLOR.PLAYER_WHITE] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_light", palette[COLOR.PLAYER_LIGHT] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_dark", palette[COLOR.PLAYER_DARK] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_black", palette[COLOR.PLAYER_BLACK] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_white", palette[COLOR.ENEMY_WHITE] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_light", palette[COLOR.ENEMY_LIGHT] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_dark", palette[COLOR.ENEMY_DARK] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_black", palette[COLOR.ENEMY_BLACK] + Color(.1, .1, .1)*cur_brightness)
		backgroundFilter.material.set_shader_param("palette_white", backgroundFilter.material.get_shader_param("game_white"))
		backgroundFilter.material.set_shader_param("palette_light", backgroundFilter.material.get_shader_param("game_light"))
		backgroundFilter.material.set_shader_param("palette_dark", backgroundFilter.material.get_shader_param("game_dark"))
		backgroundFilter.material.set_shader_param("palette_black", backgroundFilter.material.get_shader_param("game_black"))
	elif palette.size() > 4:
		playerFilter.material.set_shader_param("palette_white", palette[COLOR.PLAYER_WHITE] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_light", palette[COLOR.PLAYER_LIGHT] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_dark", palette[COLOR.PLAYER_DARK] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_black", palette[COLOR.PLAYER_BLACK] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_white", spriteFilter.material.get_shader_param("game_white"))
		spriteFilter.material.set_shader_param("palette_light", spriteFilter.material.get_shader_param("game_light"))
		spriteFilter.material.set_shader_param("palette_dark", spriteFilter.material.get_shader_param("game_dark"))
		spriteFilter.material.set_shader_param("palette_black", spriteFilter.material.get_shader_param("game_black"))
		backgroundFilter.material.set_shader_param("palette_white", backgroundFilter.material.get_shader_param("game_white"))
		backgroundFilter.material.set_shader_param("palette_light", backgroundFilter.material.get_shader_param("game_light"))
		backgroundFilter.material.set_shader_param("palette_dark", backgroundFilter.material.get_shader_param("game_dark"))
		backgroundFilter.material.set_shader_param("palette_black", backgroundFilter.material.get_shader_param("game_black"))
	else:
		playerFilter.material.set_shader_param("palette_white", playerFilter.material.get_shader_param("game_white"))
		playerFilter.material.set_shader_param("palette_light", playerFilter.material.get_shader_param("game_light"))
		playerFilter.material.set_shader_param("palette_dark", playerFilter.material.get_shader_param("game_dark"))
		playerFilter.material.set_shader_param("palette_black", playerFilter.material.get_shader_param("game_black"))
		spriteFilter.material.set_shader_param("palette_white", spriteFilter.material.get_shader_param("game_white"))
		spriteFilter.material.set_shader_param("palette_light", spriteFilter.material.get_shader_param("game_light"))
		spriteFilter.material.set_shader_param("palette_dark", spriteFilter.material.get_shader_param("game_dark"))
		spriteFilter.material.set_shader_param("palette_black", spriteFilter.material.get_shader_param("game_black"))
		backgroundFilter.material.set_shader_param("palette_white", backgroundFilter.material.get_shader_param("game_white"))
		backgroundFilter.material.set_shader_param("palette_light", backgroundFilter.material.get_shader_param("game_light"))
		backgroundFilter.material.set_shader_param("palette_dark", backgroundFilter.material.get_shader_param("game_dark"))
		backgroundFilter.material.set_shader_param("palette_black", backgroundFilter.material.get_shader_param("game_black"))

# Options-menu brightness. Controlled by slider
func set_brightness(val : int):
	cur_brightness = val
	update_colors()

# Game brightness. Moves colors up and down the color direction
func set_brightness_param(val : int):
	var spriteFilter = $SpriteFilter
	var backgroundFilter = $BackgroundFilter
	material.set_shader_param("brightness_level", val)
	if cur_palette_size > 4:
		spriteFilter.material.set_shader_param("brightness_level", val)
		playerFilter.material.set_shader_param("brightness_level", val)
	else:
		spriteFilter.material.set_shader_param("brightness_level", 0)
		playerFilter.material.set_shader_param("brightness_level", 0)
	if cur_palette_size > 12:
		backgroundFilter.material.set_shader_param("brightness_level", val)
	else:
		backgroundFilter.material.set_shader_param("brightness_level", 0)
	emit_signal("brightness_changed")
func get_brightness_param():
	return material.get_shader_param("brightness_level")

const palettes = {
	Classic = [
		Color(1, 1, 1, 1),
		Color(182.0/255, 182.0/255, 182.0/255, 1),
		Color(103.0/255, 103.0/255, 103.0/255, 1),
		Color(0, 0, 0, 1)],
	Muted = [
		Color(.83, .84, .83, 1),
		Color(.67, .68, .67, 1),
		Color(.34, .35, .34, 1),
		Color(.16, .17, .16, 1)],
	"GBoy": [
		Color(224.0/255, 248.0/255, 208.0/255, 1),
		Color(136.0/255, 192.0/255, 112.0/255, 1),
		Color(52.0/255, 104.0/255, 86.0/255, 1),
		Color(8.0/255, 24.0/255, 32.0/255, 1)],
	"GBoy2": [
		Color(0.79, 0.86, 0.62, 1),
		Color(.54, .67, .06, 1),
		Color(.19, .38, .19, 1),
		Color(.06, .22, .06, 1)],
	"SuperBoy": [
		Color(247.0/255, 231.0/255, 198.0/255, 1),
		Color(214.0/255, 142.0/255, 73.0/255, 1),
		Color(166.0/255, 55.0/255, 37.0/255, 1),
		Color(51.0/255, 30.0/255, 80.0/255, 1)],
	"VBoy": [
		Color(239.0/255, 0, 0, 1),
		Color(164.0/255, 0, 0, 1),
		Color(85.0/255, 0, 0, 1),
		Color(0, 0, 0, 1)],
	"GenWunner": [
		Color(1, 239.0/255, 1, 1),
		Color(247.0/255, 181.0/255, 140.0/255, 1),
		Color(132.0/255, 115.0/255, 156.0/255, 1),
		Color(24.0/255, 16.0/255, 16.0/255, 1)],
	"Egg Maze": [
		Color(1, 1, 181.0/255, 1),
		Color(123.0/255, 198.0/255, 123.0/255, 1),
		Color(107.0/255, 140.0/255, 66.0/255, 1),
		Color(90.0/255, 57.0/255, 33.0/255, 1)],
	"Heaven": [
		Color(206.0/255, 247.0/255, 247.0/255, 1),
		Color(247.0/255, 142.0/255, 80.0/255, 1),
		Color(158.0/255, 0, 0, 1),
		Color(30.0/255, 0, 0, 1)],
	"His Land": [
		Color(239.0/255, 247.0/255, 182.0/255, 1),
		Color(223.0/255, 166.0/255, 119.0/255, 1),
		Color(17.0/255, 198.0/255, 0, 1),
		Color(0, 0, 0, 1)],
	"MEGA 9": [
		Color(206.0/255, 206.0/255, 206.0/255, 1),
		Color(111.0/255, 158.0/255, 223.0/255, 1),
		Color(66.0/255, 103.0/255, 142.0/255, 1),
		Color(16.0/255, 37.0/255, 51.0/255, 1)],
	"Dream": [
		Color(247.0/255, 190.0/255, 247.0/255, 1),
		Color(231.0/255, 134.0/255, 134.0/255, 1),
		Color(119.0/255, 51.0/255, 231.0/255, 1),
		Color(44.0/255, 44.0/255, 150.0/255, 1)],
	"Alien": [
		Color(1, 1, 1, 1),
		Color(157.0/255, 221.0/255, 248.0/255, 1),
		Color(53.0/255, 139.0/255, 241.0/255, 1),
		Color(0, 0, 0, 1),
		Color(249.0/255, 214.0/255, 83.0/255, 1),
		Color(242.0/255, 77.0/255, 57.0/255, 1),
		Color(138.0/255, 44.0/255, 32.0/255, 1),
		Color(0, 0, 0, 1)],
	"SYSTEM": [
		Color(1, 1, 1, 1),
		Color(210.0/255, 210.0/255, 210.0/255, 1),
		Color(160.0/255, 160.0/255, 160.0/255, 1),
		Color(30.0/255, 0, 0, 1),
		Color(255.0/255, 140.0/255, 0.0/255, 1),
		Color(255.0/255, 30.0/255, 0.0/255, 1),
		Color(135.0/255, 0.0/255, 0.0/255, 1),
		Color(30.0/255, 0, 0, 1)],
	"New Venture": [
		Color("#ffffff"), Color("#68dce3"), Color("#4aa8d9"), Color("#000000"),
		Color("#FFFFFF"), Color("#F9B71A"), Color("#b76610"), Color("#3b237b"),
		Color("#FFFFFF"), Color("#fd6868"), Color("#903737"), Color("#4c152d"),
		Color("#ebf9ee"), Color("#76d69b"), Color("#30a169"), Color("#000000")],
	"Blueberry": [
		# Sky
		Color(235.0/255, 249.0/255, 243.0/255, 1),
		Color(102.0/255, 209.0/255, 207.0/255, 1),
		Color(54.0/255, 137.0/255, 181.0/255, 1),
		Color(0.0/255, 0.0/255, 0.0/255, 1),
		# Player
		Color(255.0/255, 255.0/255, 255.0/255, 1),
		Color(250.0/255, 194.0/255, 41.0/255, 1),
		Color(172.0/255, 108.0/255, 154.0/255, 1),
		Color(30.0/255, 54.0/255, 159.0/255, 1),
		# Enemy
		Color(255.0/255, 255.0/255, 255.0/255, 1),
		Color(180.0/255, 104.0/255, 253.0/255, 1),
		Color(105.0/255, 66.0/255, 174.0/255, 1),
		Color(76.0/255, 26.0/255, 96.0/255, 1)],
	"Forest": [
		Color("#FFFFFF"),
		Color("#bcd676"),
		Color("#7ba130"),
		Color("#000000"),
		Color("#eff2ee"),
		Color("#8ad888"),
		Color("#29ae37"),
		Color("#1c6338"),
		Color("#FFFFFF"),
		Color("#68affd"),
		Color("#304f7e"),
		Color("#152b4c")],
	"Margin Night": [Color("#494d9c"), Color("#2c3249"), Color("#15181e"), Color("#000000")],
	"Snatcher-Vision": [Color("#000000"), Color("#3e274f"), Color("#8346af"), Color("#d6a100")],
}
