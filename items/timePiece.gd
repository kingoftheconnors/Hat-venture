class_name timePiece

func collect_as_item(body, this):
	# Play Animation
	PlayerGameManager.pause_except([body])
	SoundSystem.fadeout_music()
	this.get_node("AnimationTree")["parameters/playback"].travel("Collect")
	body.walk_to_node(this)
	body.animate("dance")
	return false

func spawnFromBox(_collidingBody):
	pass

