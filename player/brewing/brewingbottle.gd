extends Node2D

var velo = Vector2()

func init(direc):
	velo.x = 200 * direc
	velo.y = -220

func _physics_process(delta):
	velo.y += Constants.gravity
	position += velo * delta

func _on_Area2D_body_entered(body):
	if not body.is_in_group("player"):
		if body.has_method("damage"):
			body.damage()
		queue_free()
