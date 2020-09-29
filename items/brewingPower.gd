class_name brewingPower

var blendValue = 2
func name(): return "Pon"

func power(body, this):
	body.get_power_node().acquire_power(self)
	return true

func activate(body, animator):
	animator["parameters/playback"].travel("throw")

func deactivate(body, animator):
	pass

func force_deactivate(body, animator):
	deactivate(body, animator)

func release():
	var brewhat = load("res://items/Resources/ReleasedBrewHat.tscn")
	var hat = brewhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat

func spawnFromBox(collidingBody):
	var brewhat = load("res://items/Resources/BrewingHat.tscn")
	var hat = brewhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat
