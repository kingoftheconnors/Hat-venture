class_name runningPower

var blendValue = 1
func name(): return "RunningHat"

const RUN_SPEED = 175
const LOOKAHEAD = 40

func power_equipped(body, _animator):
	body.start_run(RUN_SPEED)
	body.set_lookahead(LOOKAHEAD)

func press_power_button(body, _animator):
	body.dive()
func press_power_button_on_init(_body, _animator):
	pass

func release_power_button(_body, _animator):
	pass

func power_removed(body, _animator):
	body.stop_run()
	body.set_lookahead(0)

func release():
	var runnerhat = load("res://items/Resources/ReleasedRunnerHat.tscn")
	var hat = runnerhat.instance()
	hat.set_position(Vector2(0, -8))
	return hat
