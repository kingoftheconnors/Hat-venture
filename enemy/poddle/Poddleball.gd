extends Node2D

var velo = Vector2()
var gravityMultiplier = 0.75
var safety_time = 0.5

func init(direc):
	velo.x = 100 * direc

func _physics_process(delta):
	if safety_time > 0:
		safety_time -= delta
	#velo.y += Constants.gravity * gravityMultiplier
	position += velo * delta

func _on_Area2D_body_entered(body):
	if safety_time <= 0:
		if body.is_in_group("player"):
			if body.has_method("damage"):
				body.damage(false)
			queue_free()
