extends "res://enemy/Scripts/EnemyController.gd"

const GRAVITY = 9
var velo := Vector2.ZERO
const BOUNCE_DAMPENING_MULT : float = 0.25

# Frame process function. Moves body.
func frame(body : KinematicBody2D, sprite : Sprite, _delta):
	var prev_fall_speed = velo.y
	# Moving
	var retVelo = body.move_and_slide(velo, Vector2.UP)
	velo.y = retVelo.y + GRAVITY
	if is_on_floor():
		# Bounce off floor
		velo.y = -prev_fall_speed * BOUNCE_DAMPENING_MULT
		$CollisionShape2D.disabled = true
	# TODO: Despawn
