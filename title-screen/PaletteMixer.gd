extends TextureRect

export(Palettes.COLOR) var white = Palettes.COLOR.PLAYER_LIGHT
export(Palettes.COLOR) var light = Palettes.COLOR.PLAYER_DARK
export(Palettes.COLOR) var dark = Palettes.COLOR.PLAYER_BLACK
export(Palettes.COLOR) var black = Palettes.COLOR.WORLD_BLACK

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var palette = Gui.get_palette()
	material.set_shader_param("palette_white", select_color(palette, white, Palettes.COLOR.WORLD_WHITE))
	material.set_shader_param("palette_light", select_color(palette, light, Palettes.COLOR.WORLD_LIGHT))
	material.set_shader_param("palette_dark", select_color(palette, dark, Palettes.COLOR.WORLD_DARK))
	material.set_shader_param("palette_black", select_color(palette, black, Palettes.COLOR.WORLD_BLACK))

func select_color(palette : Array, color : int, default_color : int):
	if palette.size() > color:
		return palette[color]
	else:
		return palette[default_color]
