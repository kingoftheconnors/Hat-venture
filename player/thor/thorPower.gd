class_name thorPower

var blendValue = 3
func name(): return "ThorHat"

func power_equipped(_body, _animator):
	pass

func press_power_button(body, _animator):
	body.spin()
func press_power_button_on_init(_body, _animator):
	pass

func release_power_button(_body, _animator):
	pass

func power_removed(_body, _animator):
	pass

func release():
	var thorhat = load("res://items/Resources/ReleasedThorHat.tscn")
	var hat = thorhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat
