extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().list = SaveSystem.access_data().get_palettes()
