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

func enable():
	$ItemRoot.active = true
func disable():
	$ItemRoot.active = false

func teleport_to(goal : NodePath):
	global_position = get_node(goal).global_position

func fly_to(goal : NodePath):
	disable()
	$Tween.interpolate_property(self, "position", self.position, get_node(goal).position, 2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.start()

func fly_complete():
	enable()
