# Similar to direct_zigzag, but all zigzag movements are in
# terms of DASHES. Enemy will DASH up-left, then DASH down-left
extends "res://enemy/Scripts/EnemyController.gd"
class_name zigzag

var velo = Vector2(40, 80)
var DASH_FORCE = Vector2(40,80)
var DASH_FRICTION = 0.985
var DASH_TRESHHOLD = 30
## Initial direction. Can be any diagonal. Y value must be set
export(Vector2) var direction = Vector2(1,0)

func _ready():
	velo = DASH_FORCE * direction

# Called when the node enters the scene tree for the first time.
func frame(body : KinematicBody2D, sprite : Sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Zigzag
		velo *= DASH_FRICTION
		if abs(velo.y) <= DASH_TRESHHOLD:
			direction.y = -direction.y
			velo = direction * DASH_FORCE
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
