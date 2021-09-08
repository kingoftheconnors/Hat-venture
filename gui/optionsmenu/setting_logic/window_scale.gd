extends Node
# value: int
#	Index of one of the items in the 'resolution_list'.

# 'resolution_list' should be defined manually. Vector2(width, height).
var resolution_list: Array = [
	Vector2(256, 192),
	Vector2(256, 256),
	Vector2(320, 288)
]

func main(value: Dictionary) -> void:
	Gui.set_screen_resolution(resolution_list[value["value"]])
	if !OS.window_maximized:
		OS.center_window()
