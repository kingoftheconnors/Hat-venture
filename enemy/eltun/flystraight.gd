extends "res://enemy/Scripts/EnemyController.gd"
class_name flystraight

var velo = Vector2(40, 40)
## Initial direction. Can be any direction or diagonal.
export(Vector2) var direction = Vector2(1,0)

func _ready():
	velo = velo * direction

# Frame process function. Moves body.
func frame(body : KinematicBody2D, sprite : Sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Turn around
		if body.is_on_wall():
			direction.x = -direction.x
			velo = Vector2(-velo.x, velo.y)
		if body.is_on_floor():
			direction.y = -direction.y
			velo = Vector2(velo.x, -velo.y)
		elif body.is_on_ceiling():
			direction.y = -direction.y
			velo = Vector2(velo.x, -velo.y)
		# Turn around sprite of enemies walking backwards
		if(velo.x * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
			if sprite.scale.x > 0:
				direction.x = 1
			else:
				direction.x = -1

func get_direction() -> Vector2:
	return direction
