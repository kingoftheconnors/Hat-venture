class_name defaultPower

var blendValue = 0
func name(): return "DefaultHat"

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
