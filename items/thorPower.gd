class_name thorPower

var blendValue = 3
func name(): return "ThorHat"

func power(body, _this):
	body.get_power_node().acquire_power(self)
	return true

func activate(body, _animator):
	body.spin()

func deactivate(_body, _animator):
	pass

func force_deactivate(_body, _animator):
	pass

func release():
	var thorhat = load("res://items/Resources/ReleasedThorHat.tscn")
	var hat = thorhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat

func spawnFromBox(_collidingBody):
	var thorhat = load("res://items/Resources/ThorHat.tscn")
	var hat = thorhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat

