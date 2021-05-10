class_name runningPower

var blendValue = 1
func name(): return "RunningHat"

func collect_as_item(body, _this):
	body.get_power_node().acquire_power(self)
	return true

func activate(body, _animator):
	#animator["parameters/walk/4/conditions/running"] = true
	#animator["parameters/walk/4/conditions/not_running"] = false
	body.start_run()
func activate_on_init(body, _animator):
	activate(body, _animator)

func deactivate(body, _animator):
	#animator["parameters/walk/4/conditions/running"] = false
	#animator["parameters/walk/4/conditions/not_running"] = true
	body.stop_run()

func force_deactivate(body, animator):
	deactivate(body, animator)

func release():
	var runnerhat = load("res://items/Resources/ReleasedRunnerHat.tscn")
	var hat = runnerhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat

func spawnFromBox(_collidingBody):
	var runnerhat = load("res://items/Resources/RunnerHat.tscn")
	var hat = runnerhat.instance()
	hat.set_position(Vector2(0, -16))
	hat.get_node("Body").velo.y = -150
	return hat

