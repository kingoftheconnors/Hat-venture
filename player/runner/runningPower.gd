class_name runningPower

var blendValue = 1
func name(): return "RunningHat"

func press_power_button(body, _animator):
	#animator["parameters/walk/4/conditions/running"] = true
	#animator["parameters/walk/4/conditions/not_running"] = false
	body.start_run()
func press_power_button_on_init(body, _animator):
	press_power_button(body, _animator)

func release_power_button(body, _animator):
	#animator["parameters/walk/4/conditions/running"] = false
	#animator["parameters/walk/4/conditions/not_running"] = true
	body.stop_run()

func power_removed(body, animator):
	release_power_button(body, animator)

func release():
	var runnerhat = load("res://items/Resources/ReleasedRunnerHat.tscn")
	var hat = runnerhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat
