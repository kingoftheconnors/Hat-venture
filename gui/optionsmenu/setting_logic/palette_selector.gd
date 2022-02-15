extends Node
# value: int
#	Index of one of the items in the 'palette_list'.

func main(value: Dictionary) -> void:
	if Constants.DEBUG_MODE:
		Gui.set_palette(Palettes.palettes.keys()[value["value"]])
	else:
		var palettes = SaveSystem.access_data().get_palettes()
		if value["value"] >= palettes.size():
			value["value"] = 0
		Gui.set_palette(SaveSystem.access_data().get_palettes()[value["value"]])
