class_name runningPower

var blendValue = 1
func name(): return "RunningHat"

func power(body, this):
	body.get_power_node().set_power(self)
	return true

func activate(body, animator):
	animator["parameters/conditions/running"] = true
	animator["parameters/conditions/not_running"] = false
	body.start_run()

func deactivate(body, animator):
	animator["parameters/conditions/running"] = false
	animator["parameters/conditions/not_running"] = true
	body.stop_run()

func spawnFromBox(collidingBody):
	var runnerhat = load("res://items/Resources/RunnerHat.tscn")
	var hat = runnerhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat

