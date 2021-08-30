extends Node
# value: int
#	Index of one of the items in the 'palette_list'.

func main(value: Dictionary) -> void:
	Gui.set_palette(SaveSystem.get_palettes()[value["value"]])
