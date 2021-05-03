extends Area2D

onready var animation_player : AnimationPlayer = $"../AnimationPlayer"

func _on_Area2D_body_entered(body):
	if body.has_method("bounce"):
		animation_player.play("boing")
		yield(get_tree().create_timer(0.05), "timeout")
		if overlaps_body(body):
			body.bounce(1.5)
			body.animate_jump()
