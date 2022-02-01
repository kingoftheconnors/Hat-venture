extends KinematicBody2D

func walk_to(node_path : String, direc_during = null, direct_after = null, speed_mult = 1):
	goal_x = get_node(node_path).position.x
	direc_override = direc_during
	direc_at_goal_override = direct_after
	speed = speed_mult
	play_animation("walk")

func look_at_node(node_path : String):
	var target_x = get_node(node_path).position.x
	if position.x > target_x:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1

func walk_to_then_leave(node_path : String):
	goal_x = get_node(node_path).position.x
	leave_after_reaching_goal = true
	play_animation("walk")

func teleport_to(node_path : String):
	position = get_node(node_path).position

func play_animation(animation_name):
	$AnimationTree['parameters/playback'].travel(animation_name)
func animate(animation_name):
	play_animation(animation_name)

func _physics_process(delta):
	if goal_y != null:
			if abs(position.y - goal_y) > 3:
				if abs(velo.y) > 35:
					velo.y *= .98
				if position.y < goal_y:
					velo.y += FALL_UP_GRAVITY * speed_y
				else:
					velo.y -= FALL_UP_GRAVITY * speed_y
	else:
		velo.y += GRAVITY
	velo.x *= 0.9
	if goal_x:
		if abs(position.x - goal_x) > WALK_EPSILON:
			if position.x > goal_x:
				velo.x = -WALK_SPEED * speed
				sprite.scale.x = -1
			else:
				velo.x = WALK_SPEED * speed
				sprite.scale.x = 1
			if direc_override:
				sprite.scale.x = direc_override
		else:
			goal_x = null
			velo.x = 0
			if $AnimationTree['parameters/playback'].get_current_node() == 'walk':
				play_animation("idle")
			if direc_at_goal_override:
				sprite.scale.x = direc_at_goal_override
			if leave_after_reaching_goal:
				make_invisible()
	velo = move_and_slide(velo, Vector2.UP)

func bounce_towards(direc : int = 1):
	velo = (Vector2(direc, -0.8) * KNOCKBACK_MULTIPLIER)
func fly_to(node_path = null, speed_mult = 1):
	if node_path == null:
		goal_y = null
	else:
		goal_y = get_node(node_path).position.y
	speed_y = speed_mult

func make_visible():
	visible = true
func make_invisible():
	visible = false

var velo : Vector2
const GRAVITY = 10
const FALL_UP_GRAVITY = 4
var speed = 1
var speed_y = 1
var goal_x = null
var goal_y = null
var direc_override = null
var direc_at_goal_override = null
var leave_after_reaching_goal : bool = false
const WALK_EPSILON : float = 1.0
const WALK_SPEED = 110
const KNOCKBACK_MULTIPLIER = 140

onready var sprite = $Sprite
