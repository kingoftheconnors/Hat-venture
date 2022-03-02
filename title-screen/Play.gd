extends Node

export(String) var goto_level = "res://level-select/bedroom.tscn"
export(Gui.COVER_TYPES) var fade_type = Gui.COVER_TYPES.BLACK_TO_LOW_BRIGHTNESS

func start_game():
	SaveSystem.reset_tags()
	SoundSystem.fadeout_music()
	PlayerGameManager.start_level(goto_level, 0, fade_type)
