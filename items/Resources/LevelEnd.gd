# Dialog Starter functionality for winning a level and returning
# to the level select
extends Node2D

export(String) var next_level = "res://world1/level1.tscn"

var done = false
func end_level():
	if not done:
		PlayerGameManager.level_complete()
		PlayerGameManager.start_level(next_level)
		done = true
