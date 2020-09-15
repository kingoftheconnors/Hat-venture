extends Node

onready var sprite = get_node("EnemyCore")
export(Resource) var controller
export(int) var direction = 1
onready var controllerScript = controller.new(direction)

# Called when the node enters the scene tree for the first time.
func _process(delta):
	controllerScript.frame(self, sprite, delta)

func damage(isStomp):
	return sprite.damage(isStomp)

func get_damage():
	return sprite.get_damage()

func blast_death():
	var script = preload("res://enemy/Scripts/blastDying.gd")
	controllerScript = script.new(controllerScript.get_direction())

func smash_death():
	controllerScript.smash_death()
