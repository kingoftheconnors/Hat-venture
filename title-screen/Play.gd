extends Node

export(String) var goto_level = "res://level-select/bedroom.tscn"

func start_game():
	SoundSystem.fadeout_music()
	PlayerGameManager.start_level(goto_level, 0, Gui.COVER_TYPES.BLACK_TO_LOW_BRIGHTNESS)
