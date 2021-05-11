class_name brewingPower

var blendValue = 2
func name(): return "Pon"

func activate(_body, animator):
	animator["parameters/PlayerMovement/playback"].travel("throw")
func activate_on_init(body, _animator):
	pass

func deactivate(_body, _animator):
	pass

func force_deactivate(body, animator):
	deactivate(body, animator)

func release():
	var brewhat = load("res://items/Resources/ReleasedBrewHat.tscn")
	var hat = brewhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat
