extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if !Engine.is_editor_hint() and is_active:
		controller_obj.frame(self, sprite, delta)

func frame(body : KinematicBody2D, sprite : Sprite, delta):
	pass

func damage(isStomp):
	return sprite.damage(isStomp)
func get_damage():
	return sprite.get_damage()

func blast_death():
	var script = preload("res://enemy/Scripts/blastDying.gd")
	var death_direction : Vector2
	if typeof(controller_obj.get_direction()) == TYPE_INT:
		death_direction = Vector2(controller_obj.get_direction(), 0)
	else:
		death_direction = controller_obj.get_direction()
	controller_obj = script.new(death_direction)

func smash_death():
	frozen = true

func _on_VisibilityNotifier2D_screen_entered():
	is_active = true

func _on_VisibilityNotifier2D_screen_exited():
	is_active = false
	if spawner != null and !spawner.is_on_screen():
		respawn(spawner.position)

func is_on_screen():
	return is_active

func respawn(pos):
	self.position = pos
	sprite.animate("default")
	reset_controller_script()
	frozen = false

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
var is_active = false
var frozen = false

onready var controller_obj = self
func get_controller_script():
	return controller_obj
func reset_controller_script():
	controller_obj = self
