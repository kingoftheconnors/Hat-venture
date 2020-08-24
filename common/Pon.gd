extends Node2D

func collide():
	print("Collect pon!")
	# TODO: Update GUI
	
	$AnimationPlayer.play("collect")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		collide()
