extends "res://enemy/Scripts/EnemyController.gd"
class_name sinusoidal

var velo = Vector2(40, 0)
## Initial direction. Can be left, stationary, or right
export(int, -1, 1) var direction : int = 1
# Enemy's runtime direction
var cur_direction = Vector2(1,-1)
var wave_frame = 0

export(int, 20, 120) var wave_height : int = 50
export(float, 1, 12) var frequency : float = 3

func _ready():
	cur_direction.x = direction
	velo.x = velo.x * cur_direction.x

# Frame process function. Moves body.
func frame(body : KinematicBody2D, sprite : Sprite, _delta):
	if !frozen:
		var _ret_velo = body.move_and_slide(velo, Vector2.UP)
		# Zigzag
		wave_frame += 1
		velo.y = -wave_height*cos(frequency*wave_frame*PI/180)
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
