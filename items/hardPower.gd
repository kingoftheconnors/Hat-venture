class_name hardPower

var blendValue = 4
func name(): return "HardHat"

func collect_as_item(body, _this):
	body.get_power_node().acquire_power(self)
	return true

func activate(body, _animator):
	body.bash()
func activate_on_init(_body, _animator):
	pass

func deactivate(_body, _animator):
	pass

func force_deactivate(_body, _animator):
	pass

func release():
	var hardhat = load("res://items/Resources/ReleasedHardHat.tscn")
	var hat = hardhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat

func spawnFromBox(_collidingBody):
	var hardhat = load("res://items/Resources/HardHat.tscn")
	var hat = hardhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat

