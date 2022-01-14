# Main script of execution for enemies. All enemy movement
# scripts inherit from this one.
# Manages:
#    Movement
#    Animation
#    Animating Enemy dying (stomp or power-based)
#    Respawning
extends KinematicBody2D

## Called each phsyics frame. For a 60fps game, this method is run
## 60 times in a second, and may be run twice in a row to enforce
## that.
func _physics_process(delta):
	if !Engine.is_editor_hint() and is_active:
		controller_obj.frame(self, sprite, delta)

## Movement frame. This method is overriden to create different
## movement patterns
func frame(_body : KinematicBody2D, _sprite : Sprite, _delta):
	pass

## Direction getter function. This method is overriden to create different
## movement patterns
func get_direction() -> Vector2:
	return Vector2(0, 0)

## Attack method used by players and projectiles when attacking
## any other node. Passes request to enemy's core
func damage(isStomp):
	return sprite.damage(isStomp)
## Gets damage this enemy does to the player
func get_damage():
	return sprite.get_damage()

## Death script by player abilities (bash, spin, etc).
## Overrides the player's movement process with the classic
## fall-offscreen movement
func blast_death():
	var script = preload("res://enemy/Scripts/blastDying.gd")
	var death_direction : Vector2
	if typeof(controller_obj.get_direction()) == TYPE_INT:
		death_direction = Vector2(controller_obj.get_direction(), 0)
	else:
		death_direction = controller_obj.get_direction()
	controller_obj = script.new(death_direction)

## Death script by player stomping the enemy
func smash_death():
	frozen = true

## Signal function that tracks when player does not see this node.
## If the respawn point is also off-screen, we can respawn.
func _on_VisibilityNotifier2D_screen_entered():
	is_active = true

## Signal that tracks when player sees this respawn point.
func _on_VisibilityNotifier2D_screen_exited():
	is_active = false
	if spawner != null and !spawner.is_on_screen():
		respawn(spawner.position)

func set_is_active(flag = true):
	is_active = flag

## Getter for finding if the player can see this node
func is_on_screen():
	return is_active

## Respawns enemy
func respawn(pos):
	self.position = pos
	sprite.animate("default")
	reset_controller_script()
	frozen = false

## Root node function for getting enemy's sprite
func get_sprite():
	return sprite

## Root node function for animating enemy sprite
func animate(animation_name):
	sprite.animate(animation_name)

func _ready():
	if !Engine.is_editor_hint() and enemy_respawns:
		call_deferred("create_spawner")

## This enemy's spawner
var spawner : Node
## Function for creating an enemy's spawner, which allows enemies
## to respawn when the screen leaves the enemy's spawn point
func create_spawner():
	var spawn_obj = preload("res://enemy/RespawnPoint.tscn")
	spawner = spawn_obj.instance()
	spawner.position = self.position
	spawner.init(self)
	get_parent().add_child(spawner)

## General object spawner for misc uses (such as spawning particles or fx)
func gen_object(file_path, offset = Vector2.ZERO):
	var obj = load(file_path)
	var object_inst = obj.instance()
	object_inst.set_position(position + offset)
	get_parent().add_child(object_inst)

onready var sprite = $EnemyCore
export(bool) var is_active = false
export(bool) var enemy_respawns = true
var frozen = false

# Movement script to define the enemy's movement pattern.
# Can be overriden for temporary different patterns (such as dying)
onready var controller_obj = self
func get_controller_script():
	return controller_obj
## Force changes the controller script to this node's default
## functionality.
func reset_controller_script():
	controller_obj = self
