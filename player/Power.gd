extends Node

onready var platformController = get_node("../")
onready var animator = get_node("../AnimationTree")

export(Resource) var defaultPower
onready var power = defaultPower.new()

const RELEASED_HAT_LAUNCH_SPEED = 60
const POWER_BASE_HP = 2
var power_hp = POWER_BASE_HP

func set_power(powerType):
	if powerType.name() != power.name():
		power.force_deactivate(platformController, animator)
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
	animator["parameters/hurt/blend_position"] = int(power.blendValue)

func _unhandled_input(event):
	if event.is_action_pressed("ui_B"):
		set_power_active(true)
	if event.is_action_released("ui_B"):
		set_power_active(false)
	if event.is_action_released("ui_release"):
		release_power()
	
	if Constants.DEBUG_MODE:
		if event is InputEventKey and event.pressed and event.scancode == KEY_1:
			set_power(defaultPower.new())
			updatePowerValues()
			animator["parameters/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_2:
			var script = preload("res://items/runningPower.gd")
			set_power(script.new())
			updatePowerValues()
			animator["parameters/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_3:
			var script = preload("res://items/brewingPower.gd")
			set_power(script.new())
			updatePowerValues()
			animator["parameters/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_4:
			var script = preload("res://items/thorPower.gd")
			set_power(script.new())
			updatePowerValues()
			animator["parameters/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_5:
			var script = preload("res://items/hardPower.gd")
			set_power(script.new())
			updatePowerValues()
			animator["parameters/playback"].travel("power_get")

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
	var releaseHat = power.release()
	if releaseHat:
		releaseHat.position += get_parent().position
		releaseHat.velo.x = -platformController.get_direction()*RELEASED_HAT_LAUNCH_SPEED
		get_parent().get_parent().add_child(releaseHat)
	power = defaultPower.new()
	updatePowerValues()
	animator["parameters/playback"].travel("refresh")
