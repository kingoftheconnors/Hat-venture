extends CanvasItem

export(Palettes.COLOR) var white = Palettes.COLOR.PLAYER_LIGHT
export(Palettes.COLOR) var light = Palettes.COLOR.PLAYER_DARK
export(Palettes.COLOR) var dark = Palettes.COLOR.PLAYER_BLACK
export(Palettes.COLOR) var black = Palettes.COLOR.WORLD_BLACK

export(int) var brightness_offset = 0

func _ready():
	Gui.connect("brightness_changed", self, "update_brightness")
	Gui.connect("palette_changed", self, "update_colors")
	update_colors()
	update_brightness()
func _exit_tree():
	Gui.disconnect("brightness_changed", self, "update_brightness")
	Gui.disconnect("palette_changed", self, "update_colors")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_colors():
	var palette = Gui.get_palette()
	material.set_shader_param("palette_white", select_color(palette, white, Palettes.COLOR.WORLD_WHITE))
	material.set_shader_param("palette_light", select_color(palette, light, Palettes.COLOR.WORLD_LIGHT))
	material.set_shader_param("palette_dark", select_color(palette, dark, Palettes.COLOR.WORLD_DARK))
	material.set_shader_param("palette_black", select_color(palette, black, Palettes.COLOR.WORLD_BLACK))

func update_brightness():
	material.set_shader_param("brightness_level", Gui.get_brightness_param() + brightness_offset)

func select_color(palette : Array, color : int, default_color : int):
	if palette.size() > color:
		return palette[color]
	else:
		return palette[default_color]
