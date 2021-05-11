class_name thorPower

var blendValue = 3
func name(): return "ThorHat"

func activate(body, _animator):
	body.spin()
func activate_on_init(_body, _animator):
	pass

func deactivate(_body, _animator):
	pass

func force_deactivate(_body, _animator):
	pass

func release():
	var thorhat = load("res://items/Resources/ReleasedThorHat.tscn")
	var hat = thorhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat
