class_name thorPower

var blendValue = 3
func name(): return "ThorHat"

func power(body, this):
	body.get_power_node().set_power(self)
	return true

func activate(body, animator):
	pass

func deactivate(body, animator):
	pass

func force_deactivate(body, animator):
	deactivate(body, animator)

func release():
	pass

func spawnFromBox(collidingBody):
	var thorhat = load("res://items/Resources/ThorHat.tscn")
	var hat = thorhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat

