extends "res://enemy/Scripts/EnemyController.gd"
class_name lemming

const ENEMY_GRAVITY = 9
const DEFAULT_TURNAROUND_OFFSET = 8
var velo = Vector2(30, 0)
## Initial direction. Can be left, stationary, or right
export(int, -1, 1) var direction : int = 1

## Length beyond node to check for a cliff's edge.
## Must be set to a high value for node to properly turn around
export(int) var turnaround_offset= 8
onready var floorchecker_obj : RayCast2D = $RayCast2D

func _ready():
	velo.x = velo.x * direction

# Frame process function. Moves body.
func frame(body : KinematicBody2D, sprite : Sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Gravity
		velo.y = retVelo.y + ENEMY_GRAVITY
		# Turning around
		if body.is_on_wall() or \
			(body.is_on_floor() and floorchecker_obj \
				and not floorchecker_obj.is_colliding()):
			velo = Vector2(-velo.x, velo.y)
			direction = -direction
			# Move floor_checker
			if floorchecker_obj:
				floorchecker_obj.position.x = turnaround_offset * direction
		# Turn around sprite of enemies walking backwards
		if(direction * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)

func get_direction() -> Vector2:
	return Vector2(direction, 0)
