class_name hardPower

var blendValue = 4
func name(): return "HardHat"

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
