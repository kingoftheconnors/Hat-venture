extends "res://enemy/Scripts/EnemyController.gd"
class_name bouncy

const ENEMY_GRAVITY = 9
var velo = Vector2(40, 0)
export(Vector2) var direction = Vector2(1,0)
var frame = 0

export(int) var jump_force = 100

func _ready():
	velo.x = velo.x * direction.x
	velo.y = jump_force * direction.y

# Called when the node enters the scene tree for the first time.
func frame(body : KinematicBody2D, sprite : Sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		velo.y = retVelo.y + ENEMY_GRAVITY/2
		# Zigzag
		frame += 1
		if velo.y > jump_force or body.is_on_floor():
			direction.y = -direction.y
			velo.y = -jump_force * abs(direction.y)
			frame = 0
		# Turn around
		if body.is_on_wall():
			direction.x = -direction.x
			velo = Vector2(-velo.x, velo.y)
		# Turn around sprite of enemies walking backwards
		if(velo.x * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
			if sprite.scale.x > 0:
				direction.x = 1
			else:
				direction.x = -1

func get_direction() -> Vector2:
	return direction
