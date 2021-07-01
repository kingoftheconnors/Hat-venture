extends KinematicBody2D


func walk_to(pos : Vector2, direc_during = null, direct_after = null):
	goal_x = pos.x
	direc_override = direc_during
	direc_at_goal_override = direct_after
	play_animation("walk")

func teleport_to(pos : Vector2):
	position = pos

func play_animation(animation_name):
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
			play_animation("idle")
			if direc_at_goal_override:
				sprite.scale.x = direc_at_goal_override
	velo = move_and_slide(velo, Vector2.UP)

func make_visible():
	visible = true

var velo : Vector2
const GRAVITY = 10
var goal_x = null
var direc_override = null
var direc_at_goal_override = null
const WALK_EPSILON : float = 1.0
const WALK_SPEED = 110

onready var sprite = $Sprite
