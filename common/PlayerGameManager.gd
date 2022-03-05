# Singleton manager for the player. Keeps track of player variables
# that would otherwise be destroyed when changing scenes
# Manages:
#    Death
#    Changing levels
#    Score
#    Score multipliers
#    Pausing
#    Player-specific buffs (Special runs, Assist mode)
#    Player's current power
extends Node

func _process(delta):
	if !get_tree().paused:
		if multiplicity_decrease_time_left >= 0:
			Gui.notify_multiplicity_time(multiplicity_decrease_time_left)
			multiplicity_decrease_time_left -= delta
			# Double multiplicity decrease speed when fast_decrease is on
			if fast_decrease:
				multiplicity_decrease_time_left -= delta
			if multiplicity_decrease_time_left <= 0:
				reduce_multiplicity()

func set_multiplicity_fast_decrease(flag : bool):
	fast_decrease = flag

## Input method for debug mode effects
func _unhandled_input(event):
	if Constants.DEBUG_MODE:
		if event is InputEventKey and event.pressed and event.scancode == KEY_EQUAL:
			add_score(100)
		if event is InputEventKey and event.pressed and event.scancode == KEY_MINUS:
			score = 0; Gui.set_score(score)
		if event is InputEventKey and event.pressed and event.scancode == KEY_0:
			add_pons(3)
		if event.is_action_pressed("toggle_pause"):
			toggle_pause()

var checkpoint_level = -1
var checkpoint_pos := Vector2.ZERO
func checkpoint(level : int, pos : Vector2):
	if level > checkpoint_level:
		checkpoint_level = level
		checkpoint_pos = pos

func has_checkpoint() -> bool:
	return checkpoint_level >= 0
func get_checkpoint_position() -> Vector2:
	return checkpoint_pos
func get_spawn_num() -> int:
	return spawn_num

## Method for killing the player, and restarting
func die():
	# Get current levelname to return to after playing animation
	var levelName = get_tree().get_current_scene().filename
	# Fade to white
	var transition_length = Gui.cover()
	yield(get_tree().create_timer(transition_length), "timeout")
	reset_stats()
	# Re-load level
	unpause()
	var _success = get_tree().change_scene(levelName)
	Gui.reset_energy()
	multiplicity = 1; Gui.set_score_mult(1)
	multiplicity_decrease_time_left = -1
	#get_tree().change_scene("res://transitionScenes/death.tscn")
	var _fade_length = Gui.reveal()

## Changes scene to start a level (called by number)
func start_level(levelName : String, spawn_point : int = 0, fade_type : int = Gui.COVER_TYPES.WHITE):
	spawn_num = spawn_point
	# Fade to white
	var transition_length = Gui.cover(fade_type)
	yield(get_tree().create_timer(transition_length), "timeout")
	unpause()
	checkpoint_level = -1; checkpoint_pos = Vector2.ZERO
	Gui.reset_energy()
	Gui.show()
	# Load level
	var _success = get_tree().change_scene(levelName)
	var _fade_length = Gui.reveal()

func level_complete():
	if pons != 0:
		SaveSystem.access_data().set_pons(pons)

## Resets score and pons after a GameOver
func reset_stats():
	pons = SaveSystem.access_data().get_pons()
	Gui.set_pons(pons)
	score = 0
	Gui.set_score(score)

var default_power : Resource = preload("res://player/regular/defaultPower.gd")
var cur_power : Reference = null
func set_default_power(power : Resource):
	default_power = power

func notify_power(power: Reference):
	cur_power = power

func get_power() -> Reference:
	if cur_power != null:
		return cur_power
	return default_power.new()

func get_default_power() -> Reference:
	return default_power.new()

## Adds player score
## If affects_multiplicity is true, it increments multiplicity
func add_score(amo, affects_multiplicity = false):
	score += amo*multiplicity
	Gui.set_score(score)
	if affects_multiplicity:
		multiplicity += 1
		if multiplicity > 99:
			multiplicity = 99
		if multiplicity > 1:
			Gui.set_score_mult(multiplicity)
			multiplicity_decrease_time_left = MULTIPLICITY_TIME

## Decreases multiplicity by 1 and resets multiplicity timer
func reduce_multiplicity():
	multiplicity -= 1
	Gui.set_score_mult(multiplicity)
	if multiplicity > 1:
		multiplicity_decrease_time_left = MULTIPLICITY_TIME
	else:
		multiplicity_decrease_time_left = -1

func add_pons(amo):
	pons = pons + amo
	Gui.set_pons(pons)

var active_bodies = []
## Pauses entire game except for the specified nodes
func pause_except(active_bodies_in_pause : Array):
	for body in active_bodies_in_pause:
		body.set_pause_mode(PAUSE_MODE_PROCESS)
	active_bodies = active_bodies_in_pause
	get_tree().paused = true

## Unpauses game
func unpause():
	for body in active_bodies:
		if is_instance_valid(body):
			body.set_pause_mode(PAUSE_MODE_INHERIT)
	get_tree().paused = false

func toggle_pause():
	if get_tree().paused:
		unpause()
	else:
		pause_except([])

func set_invinciblity():
	invincibility = true

# Player variables
var pons = 0
var score = 0
var multiplicity = 1
const MULTIPLICITY_TIME = 2
var fast_decrease := false
var multiplicity_decrease_time_left = -1

# Player buffs
enum InvincibilityType {
	NONE,
	INVINCIBLE,
	INFINITE_HP
}
var invincibility : int = InvincibilityType.NONE

enum PowerDelay {
	REGULAR,
	FAST,
	INSTANT
}
var power_speed : int = PowerDelay.REGULAR

enum FrameForgiveness {
	REGULAR,
	EMPATHETIC,
	NINJA_MASTER,
	NONE
}
var frame_forgiveness : int = FrameForgiveness.REGULAR

var dive_num : int = 1
var spawn_num = 0
