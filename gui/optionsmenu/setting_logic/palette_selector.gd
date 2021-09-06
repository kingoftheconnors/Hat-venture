extends Node
# value: int
#	Index of one of the items in the 'palette_list'.

func main(value: Dictionary) -> void:
	Gui.set_palette(SaveSystem.access_data().get_palettes()[value["value"]])
