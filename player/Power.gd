extends Node

onready var platformController = $".."
onready var animator = $"../AnimationTree"

onready var power

const RELEASED_HAT_LAUNCH_SPEED = 60
const POWER_BASE_HP = 2
var power_hp = POWER_BASE_HP

func _ready():
	if PlayerGameManager:
		set_power(PlayerGameManager.get_power())
	else:
		set_power(preload("res://player/regular/defaultPower.gd").new())

func acquire_power(powerType):
	if powerType.name() != power.name():
		set_power(powerType)
		animator["parameters/PlayerMovement/playback"].travel("power_get")
		SoundSystem.start_sound(SoundSystem.SFX.POWERUP_GET)

func set_power(powerType):
	if power:
		power.power_removed(platformController, animator)
	power = powerType
	power_hp = POWER_BASE_HP
	updatePowerValues()
	PlayerGameManager.notify_power(powerType)
	power.power_equipped(platformController, animator)
	if power_pressed:
		power.press_power_button(platformController, animator)

## Updates variables in animator that control which animation is played
## based on the player's power
func updatePowerValues():
	animator["parameters/PlayerMovement/crouch/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/freefall/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/idle/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/jump/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/skid/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/walk/blend_position"] = int(power.blendValue)
	animator["parameters/PlayerMovement/hurt/blend_position"] = int(power.blendValue)

var power_pressed = false
func _process(_delta):
	if platformController.is_active():
		if !power_pressed and Input.is_action_just_pressed("ui_B"):
			if platformController.get_stun() == 0:
				power_pressed = true
				set_power_active(true)
		if power_pressed and !Input.is_action_pressed("ui_B"):
			power_pressed = false
			set_power_active(false)

func _input(event):
	if event.is_action_pressed("ui_release"):
		if platformController.get_stun() == 0:
			release_power()
	
	if Constants.DEBUG_MODE:
		if event is InputEventKey and event.pressed and event.scancode == KEY_1:
			var script = preload("res://player/runner/runningPower.gd")
			acquire_power(script.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_2:
			var script = preload("res://player/runner/runningPower.gd")
			acquire_power(script.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_3:
			var script = preload("res://player/brewing/brewingPower.gd")
			acquire_power(script.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_4:
			var script = preload("res://player/thor/thorPower.gd")
			acquire_power(script.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")
		if event is InputEventKey and event.pressed and event.scancode == KEY_5:
			var script = preload("res://player/hard/hardPower.gd")
			acquire_power(script.new())
			updatePowerValues()
			animator["parameters/PlayerMovement/playback"].travel("power_get")

func set_power_active(flag):
	if flag:
		power.press_power_button(platformController, animator)
	else:
		power.release_power_button(platformController, animator)

## Taking damage. Removes player's ability after being hurt twice
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
	set_power(PlayerGameManager.get_default_power())
	updatePowerValues()
	animator["parameters/PlayerMovement/playback"].travel("refresh")
	platformController.release_all_powers()

func silent_release_power():
	power.release()
	set_power(PlayerGameManager.get_default_power())
	updatePowerValues()
	animator["parameters/PlayerMovement/playback"].travel("refresh")
	platformController.release_all_powers()

func pause_game():
	get_tree().paused = true
func resume_game():
	get_tree().paused = false

