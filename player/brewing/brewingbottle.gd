extends Node2D

const FALLING_BODY_GRAVITY = 11
var velo = Vector2()
var moving = true
var gravityMultiplier = 0.75
onready var animator = $AnimationPlayer

func init(direc):
	velo.x = 80 * direc
	velo.y = -240

func _physics_process(delta):
	if moving:
		velo.y += FALLING_BODY_GRAVITY * gravityMultiplier
		position += velo * delta

func _on_Area2D_body_entered(body):
	if not body.is_in_group("player"):
		if body.has_method("damage"):
			body.damage(false)
		animator.play("explode")
		emit_signal("explode")
		moving = false

signal explode
