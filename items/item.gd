class_name item

func name(): return "Item"

func collect_as_item(body, _this):
	body.get_power_node().acquire_power(load(powerResourcePath()).new())
	return true

func spawnFromBox(_collidingBody):
	var runnerhat = load(powerItemPath())
	var hat = runnerhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat

func powerResourcePath(): return "res://player/regular/defaultPower.gd"
func powerItemPath(): return "res://items/Resources/RunnerHat.tscn"
