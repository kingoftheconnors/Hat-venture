class_name Palettes
extends TextureRect

var cur_palette : String = "Classic"
var cur_brightness : int = 0

func set_palette(palette_name : String):
	cur_palette = palette_name
	update_colors()

func update_colors():
	var spriteFilter = $SpriteFilter
	var playerFilter = $PlayerFilter
	
	var palette : Array = palettes[cur_palette]
	material.set_shader_param("palette_white", palette[0] + Color(.1, .1, .1)*cur_brightness)
	material.set_shader_param("palette_light", palette[1] + Color(.1, .1, .1)*cur_brightness)
	material.set_shader_param("palette_dark", palette[2] + Color(.1, .1, .1)*cur_brightness)
	material.set_shader_param("palette_black", palette[3] + Color(.1, .1, .1)*cur_brightness)
	if palette.size() > 8:
		spriteFilter.material.set_shader_param("palette_white", palette[4] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_light", palette[5] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_dark", palette[6] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_black", palette[7] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_white", palette[8] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_light", palette[9] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_dark", palette[10] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_black", palette[11] + Color(.1, .1, .1)*cur_brightness)
	elif palette.size() > 4:
		spriteFilter.material.set_shader_param("palette_white", palette[4] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_light", palette[5] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_dark", palette[6] + Color(.1, .1, .1)*cur_brightness)
		spriteFilter.material.set_shader_param("palette_black", palette[7] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_white", palette[4] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_light", palette[5] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_dark", palette[6] + Color(.1, .1, .1)*cur_brightness)
		playerFilter.material.set_shader_param("palette_black", palette[7] + Color(.1, .1, .1)*cur_brightness)
	else:
		spriteFilter.material.set_shader_param("palette_white", spriteFilter.material.get_shader_param("game_white"))
		spriteFilter.material.set_shader_param("palette_light", spriteFilter.material.get_shader_param("game_light"))
		spriteFilter.material.set_shader_param("palette_dark", spriteFilter.material.get_shader_param("game_dark"))
		spriteFilter.material.set_shader_param("palette_black", spriteFilter.material.get_shader_param("game_black"))
		playerFilter.material.set_shader_param("palette_white", playerFilter.material.get_shader_param("game_white"))
		playerFilter.material.set_shader_param("palette_light", playerFilter.material.get_shader_param("game_light"))
		playerFilter.material.set_shader_param("palette_dark", playerFilter.material.get_shader_param("game_dark"))
		playerFilter.material.set_shader_param("palette_black", playerFilter.material.get_shader_param("game_black"))

func set_brightness(val : int):
	cur_brightness = val
	update_colors()

func set_brightness_param(val : int):
	var spriteFilter = $SpriteFilter
	var playerFilter = $PlayerFilter
	material.set_shader_param("brightness_level", val)
	#spriteFilter.material.set_shader_param("brightness_level", val)
	#playerFilter.material.set_shader_param("brightness_level", val)

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
	"GBoy2": [
		Color(0.79, 0.86, 0.62, 1),
		Color(.54, .67, .06, 1),
		Color(.19, .38, .19, 1),
		Color(.06, .22, .06, 1)],
	"GBoy": [
		Color(224.0/255, 248.0/255, 208.0/255, 1),
		Color(136.0/255, 192.0/255, 112.0/255, 1),
		Color(52.0/255, 104.0/255, 86.0/255, 1),
		Color(8.0/255, 24.0/255, 32.0/255, 1)],
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
	"Morning": [
		Color(235.0/255, 249.0/255, 238.0/255, 1),
		Color(118.0/255, 214.0/255, 183.0/255, 1),
		Color(48.0/255, 161.0/255, 139.0/255, 1),
		Color(0.0/255, 0.0/255, 0.0/255, 1),
		Color(255.0/255, 255.0/255, 255.0/255, 1),
		Color(253.0/255, 104.0/255, 104.0/255, 1),
		Color(144.0/255, 55.0/255, 55.0/255, 1),
		Color(76.0/255, 21.0/255, 45.0/255, 1),
		Color(255.0/255, 255.0/255, 255.0/255, 1),
		Color(249.0/255, 183.0/255, 26.0/255, 1),
		Color(183.0/255, 102.0/255, 16.0/255, 1),
		Color(59.0/255, 35.0/255, 123.0/255, 1)],
	"Blueberry": [
		Color(235.0/255, 249.0/255, 243.0/255, 1),
		Color(102.0/255, 209.0/255, 207.0/255, 1),
		Color(54.0/255, 137.0/255, 181.0/255, 1),
		Color(0.0/255, 0.0/255, 0.0/255, 1),
		Color(255.0/255, 255.0/255, 255.0/255, 1),
		Color(180.0/255, 104.0/255, 253.0/255, 1),
		Color(105.0/255, 66.0/255, 174.0/255, 1),
		Color(76.0/255, 26.0/255, 96.0/255, 1),
		Color(255.0/255, 255.0/255, 255.0/255, 1),
		Color(250.0/255, 194.0/255, 41.0/255, 1),
		Color(172.0/255, 108.0/255, 154.0/255, 1),
		Color(30.0/255, 54.0/255, 159.0/255, 1)],
	"Forest": [
		Color(249.0/255, 249.0/255, 235.0/255, 1),
		Color(188.0/255, 214.0/255, 118.0/255, 1),
		Color(123.0/255, 161.0/255, 48.0/255, 1),
		Color(0.0/255, 0.0/255, 0.0/255, 1),
		Color(255.0/255, 255.0/255, 255.0/255, 1),
		Color(104.0/255, 175.0/255, 253.0/255, 1),
		Color(48.0/255, 79.0/255, 126.0/255, 1),
		Color(21.0/255, 43.0/255, 76.0/255, 1),
		Color(239.0/255, 242.0/255, 238.0/255, 1),
		Color(138.0/255, 216.0/255, 136.0/255, 1),
		Color(41.0/255, 174.0/255, 55.0/255, 1),
		Color(28.0/255, 99.0/255, 56.0/255, 1)],
	"Margin Night": [
		Color(73.0/255, 77.0/255, 156.0/255, 1),
		Color(44.0/255, 50.0/255, 73.0/255, 1),
		Color(21.0/255, 24.0/255, 30.0/255, 1),
		Color(0.0/255, 0.0/255, 0.0/255, 1),
		Color(220.0/255, 111.0/255, 111.0/255, 1),
		Color(194.0/255, 56.0/255, 56.0/255, 1),
		Color(126.0/255, 48.0/255, 48.0/255, 1),
		Color(62.0/255, 30.0/255, 30.0/255, 1),
		Color(216.0/255, 201.0/255, 242.0/255, 1),
		Color(174.0/255, 139.0/255, 208.0/255, 1),
		Color(180.0/255, 49.0/255, 180.0/255, 1),
		Color(100.0/255, 27.0/255, 69.0/255, 1)],
	"Snatcher-Vision": [
		Color(0.0/255, 0.0/255, 0.0/255, 1),
		Color(62.0/255, 39.0/255, 79.0/255, 1),
		Color(130.0/255, 70.0/255, 175.0/255, 1),
		Color(214.0/255, 161.0/255, 0.0/255, 1)],
}
