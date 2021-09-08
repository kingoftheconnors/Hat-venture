extends Node
# value: float
#	A value between -5 and 5. The amount of brightness.


func main(value: Dictionary) -> void:
	Gui.set_brightness(value["value"])
