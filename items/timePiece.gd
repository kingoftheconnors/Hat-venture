class_name timePiece

func collect_as_item(body, this):
	# Play Animation
	PlayerGameManager.pause_except([body])
	this.get_node("AnimationTree")["parameters/playback"].travel("Collect")
	body.animate("dance")
	return false

func spawnFromBox(_collidingBody):
	pass

