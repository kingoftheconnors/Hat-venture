extends KinematicBody2D
class_name path_follower

const ENEMY_GRAVITY = 9
export(int) var horizontal_speed = 125
var speed : float = 1
var velo := Vector2.ZERO
## Initial direction. Can be left, stationary, or right
export(int, -1, 1) var direction : int = 1

export(bool) var moving = true

onready var path_follow = $".."
var patrol_points : Array = []
var patrol_index = 1

export(int) var turnaround_offset= 8
onready var floorchecker_obj : RayCast2D = $RayCast2D

onready var sprite = $EnemyCore
var jumping = true
var jump_wait_time : float = 0.2
const JUMP_FORCE = 225

func _ready():
	refresh_floorchecker_pos()

var jump_time_counter = 0
func set_jump_wait_time(jump_wait_time_min, jump_wait_time_max):
	jump_wait_time = rand_range(jump_wait_time_min, jump_wait_time_max)

func reset():
	patrol_index = 1
	patrol_points = path_follow.curve.get_baked_points()
	refresh_floorchecker_pos()

# Frame process function. Moves body.
func _physics_process(delta):
	if patrol_points.size() == 0:
		patrol_points = path_follow.curve.get_baked_points()
	# Gravity
	velo.y = velo.y + ENEMY_GRAVITY
	# Set first frame position
	if !path_follow:
		return
	var target = patrol_points[patrol_index]
	if patrol_index < patrol_points.size() - 1:
		if target.x > self.position.x:
			velo.x = horizontal_speed * speed
		else:
			velo.x = -horizontal_speed * speed
		# Once we're close enough, change to next patrol point
		if abs(position.x - target.x) < 5:
			# Unless it's the last point, in which case, require being on floor as well
			if patrol_index + 1 < patrol_points.size() - 1 or is_on_floor():
				patrol_index = patrol_index + 1
				target = patrol_points[patrol_index]
				if patrol_index == patrol_points.size() - 1:
					emit_signal("reach_goal")
	else:
		velo.x = 0
	if is_on_floor():
		jump_time_counter += delta
		if (jump_time_counter > jump_wait_time and jumping and position.y > target.y) or is_on_wall() \
			or (is_on_floor() and floorchecker_obj and not floorchecker_obj.is_colliding() and jumping):
			jump()
			jump_time_counter = 0
	velo = move_and_slide(velo, Vector2.UP)
	# Turn around sprite of enemies walking backwards
	if(velo.x * sprite.scale.x < 0):
		sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
		refresh_floorchecker_pos()

func refresh_floorchecker_pos():
	if floorchecker_obj:
		floorchecker_obj.position.x = turnaround_offset * direction

func set_speed(_speed : float):
	speed = _speed

func jump():
	velo.y = -JUMP_FORCE

func stop_jumping():
	jumping = false

func get_timepieces():
	$AnimationTree['parameters/playback'].travel('timepiece')

func get_direction() -> Vector2:
	return Vector2(direction, 0)

signal reach_goal
