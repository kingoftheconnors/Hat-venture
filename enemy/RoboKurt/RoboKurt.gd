extends "res://enemy/Scripts/EnemyController.gd"

"""
- Hops in idle animation
- Jumps across screen or does a ground pound every seven seconds
- Flies into sky when taking damage
- Dead when health depletes
"""

var idle_count : int = 0
const ATTACK_THRESHOLD = 2
const SCREEN_SHAKE_INTENSITY = 4
const SCREEN_SHAKE_DURATION = 1.0

export(NodePath) var left_side
export(NodePath) var right_side

func increase_idle_count():
	idle_count += 1
	if idle_count >= ATTACK_THRESHOLD:
		attack()
		idle_count = 0

const ATTACK_TYPES = ["jump", "pound"]

func attack():
	var attack = ATTACK_TYPES[randi() % ATTACK_TYPES.size()]
	animator.set_condition(attack, true)

func ground_pound():
	# Drop apples
	emit_signal("ground_pound")
	# Shake screen
	get_tree().call_group("camera", "shake_screen", SCREEN_SHAKE_INTENSITY, SCREEN_SHAKE_DURATION)

func damage(isStomp):
	.damage(isStomp)
	if Constants.PHOTOSENSITIVE_MODE:
		animator.set_parameter("hurt/IsFlashing/add_amount", 0)
	else:
		animator.set_parameter("hurt/IsFlashing/add_amount", 1)
	animator.set_condition("hurt", true)

func fly_to_other_side(duration : float):
	swap_side()
	var tween = $Tween
	tween.interpolate_property(self, "position:x", position.x, cur_side.position.x, duration)
	tween.start()

func teleport_to_other_side():
	swap_side()
	$Tween.stop(self)
	position.x = cur_side.position.x
	update_direction()

func update_direction():
	if is_left_side:
		$EnemyCore.scale.x = -1
	else:
		$EnemyCore.scale.x = 1

var is_left_side : bool = false
onready var left = get_node(left_side)
onready var right = get_node(right_side)
onready var cur_side = right
func swap_side():
	if is_left_side:
		is_left_side = false
		cur_side = right
	else:
		is_left_side = true
		cur_side = left

onready var animator = $EnemyCore/AnimationTree
func _ready():
	randomize()
	is_active = true

signal ground_pound
