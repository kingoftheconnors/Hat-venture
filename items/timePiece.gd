class_name timePiece

func power(body, this):
	# Play Animation
	PlayerGameManager.pause_except([body])
	this.get_node("AnimationTree")["parameters/playback"].travel("Collect")
	body.animate("dance")
	return false

# Time pieces are not equipped as abilities, so so this isn't called
func activate(body, animator):
	pass

# Time pieces are not equipped as abilities, so this isn't called
func deactivate(body, animator):
	pass

func spawnFromBox(collidingBody):
	pass

