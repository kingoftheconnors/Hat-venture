class_name brewingPower

var blendValue = 2
func name(): return "Pon"

func collect_as_item(body, _this):
	body.get_power_node().acquire_power(self)
	return true

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

func spawnFromBox(_collidingBody):
	var brewhat = load("res://items/Resources/BrewingHat.tscn")
	var hat = brewhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat
