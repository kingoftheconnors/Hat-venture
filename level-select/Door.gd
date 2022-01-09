extends Sprite

func play_if_player(body, animation_name):
	if body.is_in_group("player"):
		$AnimationPlayer.play(animation_name)
