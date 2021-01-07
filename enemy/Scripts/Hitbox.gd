## Script for attackbox that services attack collisions with
## the get_damage function
extends Node

onready var enemyCore = $"../EnemyCore"

func get_damage():
	return enemyCore.get_damage()
