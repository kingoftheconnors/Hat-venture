extends Node

onready var platformController = get_node("../")
onready var animator = get_node("../AnimationTree")

export(Resource) var defaultPower
onready var power = defaultPower.new()

const RELEASED_HAT_LAUNCH_SPEED = 60
const POWER_BASE_HP = 2
var power_hp = POWER_BASE_HP

func acquire_power(powerType):
	if powerType.name() != power.name():
		set_power(powerType)
		animator["parameters/PlayerMovement/playback"].travel("power_get")

func set_power(powerType):
	power.force_deactivate(platformController, animator)
	power = powerType
	power_hp = POWER_BASE_HP
	updatePowerValues()

func updatePowerValues():
	animator["parameters/PlayerMovement/crouch/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/freefall/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/idle/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/jump/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/skid/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/walk/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/hurt/blend_position"] = int(power.blendValue)

func _unhandled_input(event):
	if platformController.is_active():
		if event.is_action_pressed("ui_B"):
			if platformController.get_stun() == 0:
				set_power_active(true)
		if event.is_action_released("ui_B"):
			set_power_active(false)
		if event.is_action_pressed("ui_release"):
			if platformController.get_stun() == 0:
				release_power()
	
	if Constants.DEBUG_MODE:
		if event is InputEventKey and event.pressed and event.scancode == KEY_1:
			acquire_power(defaultPower.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_2:
			var script = preload("res://items/runningPower.gd")
			acquire_power(script.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_3:
			var script = preload("res://items/brewingPower.gd")
			acquire_power(script.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_4:
			var script = preload("res://items/thorPower.gd")
			acquire_power(script.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_5:
			var script = preload("res://items/hardPower.gd")
			acquire_power(script.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")

func set_power_active(flag):
	if flag:
		power.activate(platformController, animator)
	else:
		power.deactivate(platformController, animator)

func hit():
	power_hp -= 1
	if power_hp <= 0 and power.name() != "DefaultHat":
		call_deferred("release_power")

func release_power():
	var releaseHat = power.release()
	if releaseHat:
		releaseHat.position += get_parent().position
		releaseHat.set_velo_x(-platformController.get_direction()*RELEASED_HAT_LAUNCH_SPEED)
		get_parent().get_parent().add_child(releaseHat)
	set_power(defaultPower.new())
	updatePowerValues()
	animator["parameters/PlayerMovement/playback"].travel("refresh")

func pause_game():
	get_tree().paused = true
func resume_game():
	get_tree().paused = false

