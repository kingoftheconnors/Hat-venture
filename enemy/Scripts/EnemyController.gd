tool
extends Node

# Called when the node enters the scene tree for the first time.
#func _ready():
#	if has_controller_script():
#		reset_controller_script()

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if !Engine.is_editor_hint() and is_active:
		get_controller_script().frame(self, sprite, delta)

func damage(isStomp):
	return sprite.damage(isStomp)
func get_damage():
	return sprite.get_damage()

func blast_death():
	var script = preload("res://enemy/Scripts/blastDying.gd")
	controller_script = script.new(base_direction, {})

func smash_death():
	get_controller_script().smash_death()

func _on_VisibilityNotifier2D_screen_entered():
	is_active = true

func _on_VisibilityNotifier2D_screen_exited():
	is_active = false
	if spawner != null and !spawner.is_on_screen():
		respawn(spawner.position)

func is_on_screen():
	return is_active

func respawn(pos):
	print("Respawning ", self.name)
	self.position = pos
	sprite.animate("default")
	reset_controller_script()

func get_sprite():
	return sprite

func animate(animation_name):
	sprite.animate(animation_name)

var spawner : Node
func _ready():
	if !Engine.is_editor_hint():
		call_deferred("create_spawner")

func create_spawner():
	var spawn_obj = preload("res://enemy/RespawnPoint.tscn")
	var spawner = spawn_obj.instance()
	spawner.position = self.position
	spawner.init(self)
	get_parent().add_child(spawner)

onready var sprite = get_node("EnemyCore")
export(Vector2) var base_direction = Vector2(1,0)
var is_active = false

var controller_script = null
var controller : Resource
export(Dictionary) var controller_variables
func get_controller_script():
	if controller_script == null:
		controller_script = controller.new(base_direction, controller_variables)
	return controller_script
func reset_controller_script():
	controller_script = controller.new(base_direction, controller_variables)
func has_controller_script():
	return controller_script != null

# Exporting script variables
func _get(property):
	# Getting controller
	if property == "movement/controller":
		return controller
	# Controller variables
	if controller_variables.has(property):
		return controller_variables[property]

func _set(property, value):
	# Changing controller
	if property == "movement/controller":
		controller = value
		if controller != null:
			reset_controller_script()
		property_list_changed_notify() # update inspect
		return true
	# Controller variables
	if has_controller_script():
		for prop in get_controller_script().get_script_export_list():
			if prop.name == property:
				controller_variables[prop.name] = value
				get_controller_script().update_exports(controller_variables)
				property_list_changed_notify() # update inspect
				return true
	return false

func _get_property_list():
	# Controller
	var retval = [{
		name = "movement/controller",
		type = TYPE_OBJECT,
		"usage": PROPERTY_USAGE_DEFAULT
	}]
	# Controller variables
	if has_controller_script():
		var cscript = get_controller_script()
		if cscript.has_method("get_script_export_list"):
			var exports = cscript.get_script_export_list()
			for prop in exports:
				if !controller_variables.has(prop.name):
					controller_variables[prop.name] = prop.default
			return retval + exports
	return retval
