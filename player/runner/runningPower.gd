class_name runningPower

var blendValue = 1
func name(): return "RunningHat"

const RUN_SPEED = 200
const LOOKAHEAD = 50

func power_equipped(body, _animator):
	body.start_run(RUN_SPEED)
	body.set_lookahead(LOOKAHEAD)

func press_power_button(body, _animator):
	pass
func press_power_button_on_init(body, _animator):
	pass

func release_power_button(body, _animator):
	pass

func power_removed(body, animator):
	body.stop_run()
	body.set_lookahead(0)

func release():
	var runnerhat = load("res://items/Resources/ReleasedRunnerHat.tscn")
	var hat = runnerhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat
