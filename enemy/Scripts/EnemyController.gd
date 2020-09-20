tool
extends Node

onready var sprite = get_node("EnemyCore")
export(Vector2) var direction = Vector2(1,0)

var controller : Resource
var controllerScript

# Exporting script variables
func _get(property):
	# Getting controller
	if property == "movement/controller":
		return controller
	# Controller variables
	if "movement" in property and controllerScript != null:
		if controllerScript.has_method("get_property"):
			return controllerScript.get_property(property) # One can implement custom getter logic here

# TODO: PUT VARIABLES INTO DICTIONARY AS RESOURCE SCENES
#       WON'T TECHNICALLY EXIST UNTIL STARTUP
func _set(property, value):
	# Changing controller
	if property == "movement/controller":
		controller = value
		if controllerScript != null:
			controllerScript = controller.new(direction)
		property_list_changed_notify() # update inspect
		return true
	# Controller variables
	if controllerScript != null \
		and controllerScript.has_method("set_property"):
		return controllerScript.set_property(property, value)
	return false

func _get_property_list():
	# Controller
	var retval = [{
		name = "movement/controller",
		type = TYPE_OBJECT,
		"usage": PROPERTY_USAGE_DEFAULT
	}]
	# Controller variables
	if controllerScript != null and controllerScript.has_method("get_script_export_list"):
		print(controllerScript, controllerScript.has_method("get_script_export_list"))
		return retval + controllerScript.get_script_export_list()
	return retval

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if controllerScript == null and controller != null:
		controllerScript = controller.new(direction)
	if !Engine.is_editor_hint():
		controllerScript.frame(self, sprite, delta)

func damage(isStomp):
	return sprite.damage(isStomp)

func get_damage():
	return sprite.get_damage()

func blast_death():
	var script = preload("res://enemy/Scripts/blastDying.gd")
	self.movement.controller = script

func smash_death():
	controllerScript.smash_death()
