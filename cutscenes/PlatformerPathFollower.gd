extends KinematicBody2D
class_name path_follower

const ENEMY_GRAVITY = 9
export(int) var horizontal_speed = 160
var velo := Vector2.ZERO
## Initial direction. Can be left, stationary, or right
export(int, -1, 1) var direction : int = 1

export(bool) var moving = true

onready var path_follow = $".."
var patrol_points : Array = []
var patrol_index = 1

onready var sprite = $EnemyCore
var jump_sensitivity = 10
const JUMP_FORCE = 225

func _ready():
	jump_sensitivity = jump_sensitivity * rand_range(0.5, 1)

func reset():
	patrol_index = 1
	patrol_points = path_follow.curve.get_baked_points()

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
			velo.x = horizontal_speed
		else:
			velo.x = -horizontal_speed
		# Once we're close enough, change to next patrol point
		if abs(position.x - target.x) < 5:
			# Unless it's the last point, in which case, require being on floor as well
			if patrol_index + 1 < patrol_points.size() - 1 or is_on_floor():
				patrol_index = patrol_index + 1
				target = patrol_points[patrol_index]
				if patrol_index == patrol_points.size() - 1:
					emit_signal("reach_goal")
	else:
		velo.x *= 0.8
	if is_on_floor() and target.y < position.y - jump_sensitivity:
		jump()
	velo = move_and_slide(velo, Vector2.UP)
	# Turn around sprite of enemies walking backwards
	if(velo.x * sprite.scale.x < 0):
		sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)

func jump():
	velo.y = -JUMP_FORCE

func get_timepieces():
	$AnimationTree['parameters/playback'].travel('timepiece')

func get_direction() -> Vector2:
	return Vector2(direction, 0)

signal reach_goal
