extends "res://enemy/Scripts/EnemyController.gd"
class_name bouncy

const ENEMY_GRAVITY = 9
var velo = Vector2(40, 0)
## Initial direction. Can be left, stationary, or right
export(int, -1, 1) var direction : int = 1
# Enemy's runtime direction
var cur_direction = Vector2(1,-1)
var frame = 0

export(int) var jump_force = 100

func _ready():
	cur_direction.x = direction
	velo.x = velo.x * cur_direction.x
	velo.y = jump_force * cur_direction.y

# Frame process function. Moves body.
func frame(body : KinematicBody2D, sprite : Sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		velo.y = retVelo.y + ENEMY_GRAVITY/2
		# Zigzag
		frame += 1
		if velo.y > jump_force or body.is_on_floor():
			cur_direction.y = -cur_direction.y
			velo.y = -jump_force * abs(cur_direction.y)
			frame = 0
		# Turn around
		if body.is_on_wall():
			cur_direction.x = -cur_direction.x
			velo = Vector2(-velo.x, velo.y)
		# Turn around sprite of enemies walking backwards
		if(velo.x * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
			if sprite.scale.x > 0:
				cur_direction.x = 1
			else:
				cur_direction.x = -1

func get_direction() -> Vector2:
	return cur_direction
