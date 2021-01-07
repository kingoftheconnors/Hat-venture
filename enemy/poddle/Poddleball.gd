# Damaging enemy projectile that can hurt player. Loses power and falls
# after hitting any wall
extends Node2D

const FALLING_BODY_GRAVITY = 11
var velo = Vector2()
var gravityMultiplier = 0.75
var falling = false

func init(direc):
	velo.x = 100 * direc

func _physics_process(delta):
	position += velo * delta
	if falling:
		velo.y += FALLING_BODY_GRAVITY * 50 * delta

onready var animation_player = $AnimationPlayer

func _on_Area2D_body_entered(body):
	# Colliding with tiles
	if body.get_collision_layer_bit(1): # Check if body is on wall layer
		velo = Vector2(-velo.x/10, -75)
		falling = true
		animation_player.play("disable")
