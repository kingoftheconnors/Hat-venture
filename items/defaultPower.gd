class_name defaultPower

var blendValue = 0
func name(): return "DefaultHat"

func power(body, this):
	body.get_power_node().set_power(self)
	return true

func activate(body, animator):
	body.dive()

func deactivate(body, animator):
	pass

func force_deactivate(body, animator):
	deactivate(body, animator)

func spawnFromBox(collidingBody):
	pass