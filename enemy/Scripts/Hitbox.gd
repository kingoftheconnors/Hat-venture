## Script for attackbox that services attack collisions with
## the get_damage function
extends Node

onready var enemyCore = $"../EnemyCore"
onready var enemyBody = get_parent()

func get_damage():
	return enemyCore.get_damage()

func get_body() -> Node:
	return enemyBody
