extends "res://enemy/Scripts/EnemyController.gd"

"""
- Hops in idle animation
- Jumps across screen or does a ground pound every seven seconds
- Flies into sky when taking damage
- Dead when health depletes
"""

var idle_count : int = 0
const MAX_HEALTH = 6
const HEALTH_TO_PHASE_2 = 3
const ATTACK_THRESHOLD = 2
const SCREEN_SHAKE_INTENSITY = 4
const SCREEN_SHAKE_DURATION = 1.0
const SCREAM_SHAKE_INTENSITY = 8
const SCREAM_SHAKE_DURATION = 2.0

export(NodePath) var left_side
export(NodePath) var right_side
export(NodePath) var timepiece_goal

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
func scream():
	get_tree().call_group("camera", "shake_screen", SCREAM_SHAKE_INTENSITY, SCREAM_SHAKE_DURATION)
	SoundSystem.start_sound(SoundSystem.SFX.ROBOHEN_SCREAM)

var velo : Vector2 = Vector2.ZERO
var falling : bool = false
const GRAVITY = 13
func fall():
	velo = Vector2($EnemyCore.scale.x*100, -200)
	falling = true
func fall_towards_right():
	velo = Vector2(100, -200)
	falling = true
func end_fall():
	falling = false
	velo = Vector2.ZERO
func _physics_process(_delta):
	if falling:
		velo += Vector2.DOWN*GRAVITY
		var _v = move_and_slide(velo, Vector2.UP)
		if get_slide_count() > 0:
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if abs(collision.normal.y) > abs(collision.normal.x) \
					and collision.collider.get_collision_layer_bit(1):
					animator.set_parameter("hurt/HurtState/conditions/fall_complete", true)
					animator.set_parameter("die/die/conditions/fall_complete", true)
					break

func damage(isStomp):
	var killed = .damage(isStomp)
	if $EnemyCore.enemy_hp == 3:
		animator.set_condition("phase_1", false)
		animator.set_condition("phase_2", true)
	if Constants.PHOTOSENSITIVE_MODE:
		animator.set_parameter("hurt/IsFlashing/add_amount", 0)
	else:
		animator.set_parameter("hurt/IsFlashing/add_amount", 1)
	animator.set_condition("hurt", true)
	emit_signal("hurt")
	idle_count = 0
	Gui.update_boss_health($EnemyCore.enemy_hp, MAX_HEALTH)
	if killed:
		emit_signal("dead")

func fly_to_other_side(duration : float):
	swap_side()
	fly_to_current_side(duration)
func fly_to_current_side(duration : float):
	var tween = $Tween
	tween.interpolate_property(self, "position:x", position.x, cur_side.position.x, duration)
	tween.start()

func fly_to_player(duration : float):
	var tween = $Tween
	var player_nodes = get_tree().get_nodes_in_group("player_root")
	if player_nodes.size() > 0:
		tween.interpolate_property(self, "global_position:x", global_position.x, player_nodes[0].global_position.x, duration)
		set_side_to_closest_to(player_nodes[0].global_position.x)
		tween.start()
	else:
		fly_to_other_side(duration)

func set_side_to_closest_to_current_pos():
	set_side_to_closest_to(global_position.x)
func set_side_to_closest_to(position_x : float):
	if abs(position_x - left.global_position.x) < abs(position_x - right.global_position.x):
		is_left_side = true
		cur_side = left
	else:
		is_left_side = false
		cur_side = right

func teleport_to_other_side():
	swap_side()
	$Tween.stop(self)
	position.x = cur_side.position.x
	update_direction()

func stop_moving_to_any_side():
	$Tween.stop(self)

func update_direction():
	if is_left_side:
		$EnemyCore.scale.x = -1
	else:
		$EnemyCore.scale.x = 1

func start_gui():
	Gui.boss_start(MAX_HEALTH)
	$EnemyCore.enemy_hp = MAX_HEALTH
func turn_on():
	animator.active = true

func pause_game():
	PlayerGameManager.pause_except([self])
	falling = false
	velo = Vector2.ZERO
	$Tween.stop_all()
func unpause_game():
	PlayerGameManager.unpause()
func set_brightness(val : int):
	Gui.set_brightness_param(val)
func explosion_complete():
	emit_signal("exploded")

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

signal ground_pound
signal hurt
signal dead
signal exploded
