class_name defaultPower

var blendValue = 0
func name(): return "DefaultHat"

func press_power_button(body, _animator):
	body.dive()
func press_power_button_on_init(_body, _animator):
	pass

func release_power_button(_body, _animator):
	pass

func power_removed(body, animator):
	release_power_button(body, animator)
	body.undive()

func release():
	pass
