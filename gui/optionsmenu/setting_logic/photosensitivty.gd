extends Node
# value: bool
#	Whether game is Photosensitive or not
func main(value: Dictionary) -> void:
	Constants.PHOTOSENSITIVE_MODE = value["value"]
