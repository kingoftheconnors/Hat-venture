extends TextureRect

func set_palette(palette_name):
	var new_palette = palettes[palette_name]
	material.set_shader_param("palette_white", new_palette[0])
	material.set_shader_param("palette_light", new_palette[1])
	material.set_shader_param("palette_dark", new_palette[2])
	material.set_shader_param("palette_black", new_palette[3])


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
