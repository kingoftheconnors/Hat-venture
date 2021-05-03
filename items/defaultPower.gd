class_name defaultPower

var blendValue = 0
func name(): return "DefaultHat"

func power(body, _this):
	body.get_power_node().acquire_power(self)
	return true

func activate(body, _animator):
	body.dive()
func activate_on_init(_body, _animator):
	pass

func deactivate(_body, _animator):
	pass

func force_deactivate(body, animator):
	deactivate(body, animator)
	body.undive()

func release():
	pass

func spawnFromBox(_collidingBody):
	pass
