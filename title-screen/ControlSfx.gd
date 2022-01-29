extends Node

export(sound_system.SFX) var TRAVERSE_SFX = sound_system.SFX.SKID2
export(sound_system.SFX) var SELECT_SFX = sound_system.SFX.STOMP2

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_children(get_children())

func connect_children(children):
	for node in children:
		if node is Control and node.focus_mode != Control.FOCUS_NONE:
			node.connect("focus_entered", self, "play_traverse_sfx")
		if node is Button:
			node.connect("pressed", self, "play_select_sfx")
		if node is HSlider:
			node.connect("value_changed", self, "play_traverse_sfx")
		if node is Container:
			connect_children(node.get_children())

func play_traverse_sfx(_unused_param = null):
	SoundSystem.start_sound(TRAVERSE_SFX)
func play_select_sfx(_unused_param = null):
	SoundSystem.start_sound(SELECT_SFX)
