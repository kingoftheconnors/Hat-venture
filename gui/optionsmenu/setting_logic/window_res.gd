extends Node
# value: int
#	Index of one of the items in the 'resolution_list'.

# 'resolution_list' should be defined manually. Vector2(width, height).
var resolution_list: Array = [
	Vector2(640, 360),#(640, 360),
	Vector2(480, 320), # GBA resolution x 2
	Vector2(320, 256) # Gameboy with less square-like appearance
	#Vector2(256, 192), # DS resolution
	#Vector2(256, 256),
	#Vector2(320, 288) # Gameboy and Sega Gamegear resolution x 2
]

func main(value: Dictionary) -> void:
	Gui.set_screen_resolution(resolution_list[value["value"]])
	if !OS.window_maximized:
		OS.center_window()
