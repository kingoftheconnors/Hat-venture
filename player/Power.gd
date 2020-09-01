extends Node

onready var platformController = get_node("../")
onready var animator = get_node("../AnimationTree")
var power = Constants.Power.DEFAULT

const POWER_BASE_HP = 2
var power_hp = POWER_BASE_HP

# Called when the node enters the scene tree for the first time.
func set_power(powerType):
	power = powerType
	power_hp = POWER_BASE_HP
	updatePowerValues()
	animator["parameters/playback"].travel("power_get")

func updatePowerValues():
	animator["parameters/crouch/blend_position"] = int(power)
	animator["parameters/freefall/blend_position"] = int(power)
	animator["parameters/idle/blend_position"] = int(power)
	animator["parameters/jump/blend_position"] = int(power)
	animator["parameters/skid/blend_position"] = int(power)
	animator["parameters/walk/blend_position"] = int(power)
	
	# Turn off all powers
	for powerType in Constants.Power:
		set_power_active(Constants.Power[powerType], false)

func _unhandled_input(event):
	if event.is_action_pressed("ui_B"):
		set_power_active(power, true)
	if event.is_action_released("ui_B"):
		set_power_active(power, false)

func set_power_active(type, flag):
	if power == Constants.Power.DEFAULT:
		if flag:
			platformController.dive()
	if power == Constants.Power.RUNNER:
		animator["parameters/conditions/running"] = flag
		animator["parameters/conditions/not_running"] = !flag
		if flag:
			platformController.start_run()
		else:
			platformController.stop_run()
	if power == Constants.Power.BREWER:
		animator["parameters/playback"].travel("throw")
		#if flag:
		#	platformController.throw()

func hit():
	power_hp -= 1
	if power_hp <= 0 and power != Constants.Power.DEFAULT:
		power = Constants.Power.DEFAULT
		updatePowerValues()
		animator["parameters/playback"].travel("refresh")
