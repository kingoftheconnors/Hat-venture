extends Area2D

func _on_Ladder_body_entered(body):
	if body.is_in_group("player"):
		print("Entered ", self)
		body.on_ladder(self)

func _on_Ladder_body_exited(body):
	if body.is_in_group("player"):
		print(body, " - ", self)
		body.off_ladder()
