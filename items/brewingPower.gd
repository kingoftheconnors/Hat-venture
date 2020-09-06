extends Object

var blendValue = 2
func name(): return "Pon"

func power(body, this):
	body.get_power_node().set_power(self)
	return true

func activate(body, animator):
	animator["parameters/playback"].travel("throw")
	var brewbottle = load("res://player/brewing/BrewingBottle.tscn")
	var bottle = brewbottle.instance()
	bottle.position = body.position
	bottle.init(body.get_direction())
	body.get_parent().add_child(bottle)

func deactivate(body, animator):
	pass

func spawnFromBox(collidingBody):
	var brewhat = load("res://items/Resources/BrewingHat.tscn")
	var hat = brewhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat
