# Dialog Starter functionality for winning a level and returning
# to the level select
extends Node2D

export(String) var next_level = "res://world1/level1.tscn"

func end_level():
	PlayerGameManager.level_complete()
	PlayerGameManager.start_level(next_level)
