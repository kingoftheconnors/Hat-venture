extends Node

export(String) var goto_level = "res://level-select/bedroom.tscn"

func start_game():
	PlayerGameManager.start_level(goto_level)
