extends Node
# value: int
#	Index of one of the items in the 'scale_list'.

var scale_list: Array = [1,2,3,4,5]

func main(value: Dictionary) -> void:
	Gui.set_screen_multiplier(scale_list[value["value"]])
