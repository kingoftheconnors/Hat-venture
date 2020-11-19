class_name timePiece

func power(body, this):
	# Play Animation
	this.get_node("AnimationTree")["parameters/playback"].travel("Collect")
	body.force_animation("dance")
	return false

# Time pieces are not equipped as abilities, so so this isn't called
func activate(body, animator):
	pass

# Time pieces are not equipped as abilities, so this isn't called
func deactivate(body, animator):
	pass

func spawnFromBox(collidingBody):
	pass

