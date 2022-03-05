class_name brewingPower

var blendValue = 2
func name(): return "Pon"

func power_equipped(_body, _animator):
	pass

func press_power_button(_body, animator):
	animator["parameters/PlayerMovement/playback"].travel("throw")
func press_power_button_on_init(_body, _animator):
	pass

func release_power_button(_body, _animator):
	pass

func power_removed(body, animator):
	release_power_button(body, animator)

func release():
	var brewhat = load("res://items/Resources/ReleasedBrewHat.tscn")
	var hat = brewhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat
