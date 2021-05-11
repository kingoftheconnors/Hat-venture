class_name hardPower

var blendValue = 4
func name(): return "HardHat"

func press_power_button(body, _animator):
	body.bash()
func press_power_button_on_init(_body, _animator):
	pass

func release_power_button(_body, _animator):
	pass

func power_removed(_body, _animator):
	pass

func release():
	var hardhat = load("res://items/Resources/ReleasedHardHat.tscn")
	var hat = hardhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat
