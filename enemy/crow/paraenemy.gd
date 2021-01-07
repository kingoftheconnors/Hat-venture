extends "res://enemy/Scripts/EnemyController.gd"
class_name paraenemy

const ENEMY_GRAVITY = 8
var velo = Vector2(30, 0)
var JUMP_FORCE = 170
## Initial direction. Can be left, stationary, or right
export(int, -1, 1) var direction : int = 1

func _ready():
	velo.x = velo.x * direction

# Frame process function. Moves body.
func frame(body : KinematicBody2D, sprite : Sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Gravity
		velo.y = retVelo.y + ENEMY_GRAVITY
		# Jumping
		if body.is_on_floor():
			velo.y = -JUMP_FORCE
		if body.is_on_wall():
			velo = Vector2(-velo.x, velo.y)
		# Turn around sprite of enemies walking backwards
		if(velo.x * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
			if sprite.scale.x > 0:
				direction = 1
			else:
				direction = -1

func get_direction() -> Vector2:
	return Vector2(direction, 0)
