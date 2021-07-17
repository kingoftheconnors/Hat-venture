extends TextureRect

var cur_palette : String = "Classic"
var cur_brightness : int = 0

func set_palette(palette_name : String):
	cur_palette = palette_name
	update_colors()

func update_colors():
	var palette = palettes[cur_palette]
	material.set_shader_param("palette_white", palette[0] + Color(.1, .1, .1)*cur_brightness)
	material.set_shader_param("palette_light", palette[1] + Color(.1, .1, .1)*cur_brightness)
	material.set_shader_param("palette_dark", palette[2] + Color(.1, .1, .1)*cur_brightness)
	material.set_shader_param("palette_black", palette[3] + Color(.1, .1, .1)*cur_brightness)

func set_brightness(val : int):
	cur_brightness = val
	update_colors()

const palettes = {
	Classic = [
		Color(1, 1, 1, 1),
		Color(.67, .68, .67, 1),
		Color(.34, .35, .34, 1),
		Color(0, 0, 0, 1)],
	Muted = [
		Color(.83, .84, .83, 1),
		Color(.67, .68, .67, 1),
		Color(.34, .35, .34, 1),
		Color(.16, .17, .16, 1)],
	GBoy = [
		Color(0.79, 0.86, 0.62, 1),
		Color(.54, .67, .06, 1),
		Color(.19, .38, .19, 1),
		Color(.06, .22, .06, 1)]
}
