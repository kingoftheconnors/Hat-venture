class_name pon

func power(body, this):
	print("Collect pon!")
	# TODO: Update GUI
	
	return true

# Pons are not equipped as abilities, so so this isn't called
func activate(body, animator):
	pass

# Pons are not equipped as abilities, so this isn't called
func deactivate(body, animator):
	pass

func spawnFromBox(collidingBody):
	# Get pon
	power(null, null)
	# Spawn Pon Animation
	var pon = load("res://items/Resources/Pon.tscn")
	var instancedPon = pon.instance()
	instancedPon.set_position(Vector2(0, -16))
	instancedPon.get_node("AnimationPlayer").play("collect")
	return instancedPon

