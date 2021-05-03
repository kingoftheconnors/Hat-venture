class_name timePiece

func power(body, this):
	# Play Animation
	PlayerGameManager.pause_except([body])
	this.get_node("AnimationTree")["parameters/playback"].travel("Collect")
	body.animate("dance")
	return false

# Time pieces are not equipped as abilities, so so this isn't called
func activate(_body, _animator):
	pass
func activate_on_init(_body, _animator):
	pass

# Time pieces are not equipped as abilities, so this isn't called
func deactivate(_body, _animator):
	pass

func spawnFromBox(_collidingBody):
	pass

