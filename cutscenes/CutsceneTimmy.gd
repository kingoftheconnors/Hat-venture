extends KinematicBody2D

func walk_to(node_path : String, direc_during = null, direct_after = null):
	goal_x = get_node(node_path).position.x
	direc_override = direc_during
	direc_at_goal_override = direct_after
	play_animation("walk")

func walk_to_then_leave(node_path : String):
	goal_x = get_node(node_path).position.x
	leave_after_reaching_goal = true
	play_animation("walk")

func teleport_to(node_path : String):
	position = get_node(node_path).position

func play_animation(animation_name):
	print(animation_name)
	$AnimationTree['parameters/playback'].travel(animation_name)

func _physics_process(delta):
	velo.y += GRAVITY
	velo.x *= 0.9
	if goal_x:
		if abs(position.x - goal_x) > WALK_EPSILON:
			if position.x > goal_x:
				velo.x = -WALK_SPEED
				sprite.scale.x = -1
			else:
				velo.x = WALK_SPEED
				sprite.scale.x = 1
			if direc_override:
				sprite.scale.x = direc_override
		else:
			goal_x = null
			velo.x = 0
			play_animation("idle")
			if direc_at_goal_override:
				sprite.scale.x = direc_at_goal_override
			if leave_after_reaching_goal:
				make_invisible()
	velo = move_and_slide(velo, Vector2.UP)

func make_visible():
	visible = true
func make_invisible():
	visible = false

var velo : Vector2
const GRAVITY = 10
var goal_x = null
var direc_override = null
var direc_at_goal_override = null
var leave_after_reaching_goal : bool = false
const WALK_EPSILON : float = 1.0
const WALK_SPEED = 110

onready var sprite = $Sprite
