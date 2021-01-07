extends "res://enemy/Scripts/EnemyController.gd"
class_name direct_zigzag

var velo = Vector2(40, 40)
var DASH_FORCE = Vector2(40,40)
## Initial direction. Can be any diagonal. Y value must be set
export(Vector2) var direction = Vector2(1,-1)

## Number of physics frames before node will invert its Y direction
export(int) var turnaround_time = 100
var frame = 0

func _ready():
	velo = DASH_FORCE * direction

# Frame process function. Moves body.
func frame(body : KinematicBody2D, sprite : Sprite, delta):
	if !frozen:
		body.move_and_slide(velo, Vector2.UP)
		# Zigzag
		frame += 1
		if frame > turnaround_time:
			direction.y = -direction.y
			velo = direction * DASH_FORCE
			frame = 0
		# Turn around
		if body.is_on_wall():
			direction.x = -direction.x
			velo = Vector2(-velo.x, velo.y)
		if body.is_on_floor() or body.is_on_ceiling():
			direction.y = -direction.y
			velo = direction * DASH_FORCE
			frame = turnaround_time - frame
		# Turn around sprite of enemies walking backwards
		if(velo.x * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
			if sprite.scale.x > 0:
				direction.x = 1
			else:
				direction.x = -1

func get_direction() -> Vector2:
	return direction
