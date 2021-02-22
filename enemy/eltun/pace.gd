extends "res://enemy/Scripts/EnemyController.gd"
class_name pace

var velo = Vector2(40, 40)
var DASH_FORCE = Vector2(40,40)
## Initial direction. Can be any diagonal.
export(Vector2) var direction = Vector2(1,0)
var pace_frame = 0

## Number of physics frames before node will turn around
export(int) var turnaround_time = 150

func _ready():
	velo = DASH_FORCE * direction

# Frame process function. Moves body.
func frame(body : KinematicBody2D, sprite : Sprite, _delta):
	if !frozen:
		var _ret_velo = body.move_and_slide(velo, Vector2.UP, true)
		# Zigzag
		pace_frame += 1
		if pace_frame > turnaround_time:
			direction = -direction
			velo = direction * DASH_FORCE
			pace_frame = 0
		# Turn around
		if body.is_on_wall():
			direction.x = -direction.x
			velo = Vector2(-velo.x, velo.y)
			pace_frame = turnaround_time - pace_frame
		if body.is_on_floor() or body.is_on_ceiling():
			direction.y = -direction.y
			velo = direction * DASH_FORCE
			pace_frame = turnaround_time - pace_frame
		# Turn around sprite of enemies walking backwards
		if(velo.x * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
			if sprite.scale.x > 0:
				direction.x = 1
			else:
				direction.x = -1

func get_direction() -> Vector2:
	return direction
