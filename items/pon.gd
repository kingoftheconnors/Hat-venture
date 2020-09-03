extends Object

func power(body, this):
	print("Collect pon!")
	# TODO: Update GUI
	
	this.get_node("AnimationPlayer").play("collect")
	return false

# Pons are not equipped as abilities, so so this isn't called
func activate(body, animator):
	pass

# Pons are not equipped as abilities, so this isn't called
func deactivate(body, animator):
	pass

func spawnFromBox(collidingBody):
	var pon = load("res://items/Resources/Pon.tscn")
	var defeatedMafia = pon.instance()
	defeatedMafia.set_position(Vector2(0, -16))
	defeatedMafia.collect(collidingBody)
	return defeatedMafia

