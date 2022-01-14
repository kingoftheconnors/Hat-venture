extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	Gui.get_node("DebugMode").connect("debug_mode_changed", self, "update_list")
	update_list()

func update_list():
	if Constants.DEBUG_MODE:
		get_parent().list = Palettes.palettes.keys()
	else:
		get_parent().list = SaveSystem.access_data().get_palettes()
