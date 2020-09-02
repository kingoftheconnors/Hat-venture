extends Object

static func power(body, this):
	print("Collect pon!")
	# TODO: Update GUI
	
	this.get_node("AnimationPlayer").play("collect")
	return false
