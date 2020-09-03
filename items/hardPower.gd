extends Object

var blendValue = 4
func name(): return "HardHat"

func power(body, this):
	body.get_power_node().set_power(self)
	return true

func activate(body, animator):
	pass

func deactivate(body, animator):
	pass

func spawnFromBox(collidingBody):
	var hardhat = load("res://items/Resources/HardHat.tscn")
	var hat = hardhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat

