extends Node

onready var platformController = get_node("../")
onready var animator = get_node("../AnimationTree")

export(Resource) var defaultPower
onready var power = defaultPower.new()

const POWER_BASE_HP = 2
var power_hp = POWER_BASE_HP

# Called when the node enters the scene tree for the first time.
func set_power(powerType):
	power.deactivate(platformController, animator)
	power = powerType
	power_hp = POWER_BASE_HP
	updatePowerValues()
	animator["parameters/playback"].travel("power_get")

func updatePowerValues():
	animator["parameters/crouch/blend_position"] = int(power.blendValue)
	animator["parameters/freefall/blend_position"] = int(power.blendValue)
	animator["parameters/idle/blend_position"] = int(power.blendValue)
	animator["parameters/jump/blend_position"] = int(power.blendValue)
	animator["parameters/skid/blend_position"] = int(power.blendValue)
	animator["parameters/walk/blend_position"] = int(power.blendValue)

func _unhandled_input(event):
	if event.is_action_pressed("ui_B"):
		set_power_active(true)
	if event.is_action_released("ui_B"):
		set_power_active(false)
	if event.is_action_released("ui_release"):
		release_power()

func set_power_active(flag):
	if flag:
		power.activate(platformController, animator)
	else:
		power.deactivate(platformController, animator)

func hit():
	power_hp -= 1
	if power_hp <= 0 and power.name() != "DefaultHat":
		release_power()

func release_power():
		power = defaultPower.new()
		updatePowerValues()
		animator["parameters/playback"].travel("refresh")
