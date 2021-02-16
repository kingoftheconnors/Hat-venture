# Singleton manager for the player. Keeps track of player variables
# that would otherwise be destroyed when changing scenes
# Manages:
#    Death
#    Score
#    Score multipliers
#    Lives
#    Pausing
#    Player-specific buffs (Special runs, Assist mode)
extends Node

func _process(delta):
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

## Method for killing the player, and giving a gameover
## if the players' lives decreases to 0
func die():
	# Get current levelname to return to after playing animation
	var levelName = get_tree().get_current_scene().filename
	# Fade to white
	animationPlayer.play("cover")
	yield(get_tree().create_timer(.6), "timeout")
	unpause()
	pons = 0; Gui.set_pons(pons)
	lives -= 1; Gui.set_lives(lives)
	# Game over
	if lives <= 0:
		Gui.hide()
		score = 0; Gui.set_score(score);
		multiplicity = 1; Gui.set_score_mult(1)
		multiplicity_decrease_time_left = -1
		var _success = get_tree().change_scene("res://levelgameover/gameOver.tscn")
		animationPlayer.play("reveal") # Starts with covering screen
	else:
		# Re-load level
		var _success = get_tree().change_scene(levelName)
		Gui.reset_energy()
		multiplicity = 1; Gui.set_score_mult(1)
		multiplicity_decrease_time_left = -1
		#get_tree().change_scene("res://transitionScenes/death.tscn")
		animationPlayer.play("reveal") # Uncover screen after loading level

## Changes scene to start a level (called by number)
func start_level(levelNum : String):
	# Get levelname to return to after playing animation
	var levelName = "res://level" + levelNum + "/level" + levelNum + ".tscn"
	# Fade to white
	animationPlayer.play("cover")
	yield(get_tree().create_timer(.6), "timeout")
	unpause()
	pons = 0; Gui.set_pons(pons)
	score = 0; Gui.set_score(score)
	lives = 4; Gui.set_lives(lives)
	Gui.reset_energy()
	Gui.show()
	# Load level
	var _success = get_tree().change_scene(levelName)
	animationPlayer.play("reveal")

## Adds player score
## If affects_multiplicity is true, it increments multiplicity
func add_score(amo, affects_multiplicity = false):
	score += amo*multiplicity
	Gui.set_score(score)
	if affects_multiplicity:
		multiplicity += 1
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
	add_score(amo*25)
	if pons >= 100:
		pons = pons - 100
		PlayerGameManager.one_up()
	Gui.set_pons(pons)

func one_up():
	lives += 1
	Gui.set_lives(lives)

var active_bodies = []
## Pauses entire game except for the specified nodes
func pause_except(active_bodies_in_pause):
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

func set_invinciblity():
	invincibility = true

# Player variables
var lives = 3
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
	INFINITE_LIVES,
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

onready var animationPlayer = $AnimationPlayer
