extends Node

onready var enemyCore = get_node('../EnemyCore')

func get_damage():
	return enemyCore.get_damage()
