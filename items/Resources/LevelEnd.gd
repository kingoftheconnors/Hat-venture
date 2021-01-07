# Dialog Starter functionality for winning a level and returning
# to the level select
extends Node2D

func end_level():
	PlayerGameManager.start_level("1") # TODO: Change to levelSelect once it's made
