extends Node
# value: int
#	Index of one of the items in the 'palette_list'.

# 'palette_list' should be defined manually. String of palettes.
const palette_list : Array = [
	"Classic",
	"Muted",
	"GBoy"
]

func main(value: Dictionary) -> void:
	Gui.set_palette(palette_list[value["value"]])
