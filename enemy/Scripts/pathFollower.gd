extends Node2D

export(int) var base_speed = 100
export (NodePath) var patrol_path
export(bool) var active = true
var patrol_curve

export(int, 100) var patrol_start_percent
var patrol_index = 0
var velocity = Vector2()

enum EffectType {Spectral, Shadow}
export(EffectType) var effect
export(int) var effectSize = 50

func _ready():
	if patrol_path:
		patrol_curve = get_node(patrol_path).curve
	patrol_index = (patrol_start_percent * patrol_curve.get_point_count())/100

var direction = Vector2(1, 1)
func _physics_process(delta):
	if !patrol_path:
		return
	var target = patrol_curve.get_point_position(patrol_index)
	if position.distance_to(target) < max(1, base_speed/100):
		patrol_index = wrapi(patrol_index + 1, 0, patrol_curve.get_point_count())
		target = patrol_curve.get_point_position(patrol_index)
	if active:
		velocity = (target - position).normalized() * base_speed
	
	position += velocity * delta
	
	# Scaling rigidbodies isn't supported.
	# A different way will be needed for turning around

func _wait(_args):
	velocity = Vector2(0, 0)
	active = false

# Start method. Use this method as part of a signal or animation
# to start pathFollower moving
#
# USE CASE: An Area2D added to a moving platform signals this
# method to start the platform, which can start it when active
# is set to false by default.
func _resume(_args):
	velocity = Vector2(0, 0)
	active = true
