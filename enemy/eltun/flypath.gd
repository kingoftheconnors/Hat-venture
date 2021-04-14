extends "res://enemy/Scripts/EnemyController.gd"
class_name flypath

var velo = Vector2()
var move_speed = 60
## Initial direction. Can be any left or right along an enemy's path
export(int) var direction : int = 1
## Path to a Path2D node the enemy follows
export(NodePath) var flight_path
var patrol_points : Array = []
var patrol_index = -1

# Frame process function. Moves body.
func frame(body : KinematicBody2D, sprite : Sprite, _delta):
	# Set patrol baked points
	if !flight_path.is_empty() and flight_path.get_name_count() > 0:
		if patrol_points.size() == 0:
			patrol_points = get_node(flight_path).curve.get_baked_points()
		# Set first frame position
		if patrol_index < 0:
			set_first_patrol_index(body)
		elif !frozen:
			if !flight_path:
				return
			var target = patrol_points[patrol_index]
			if body.position.distance_to(target) < 1:
				patrol_index = wrapi(patrol_index + direction, 0, patrol_points.size())
				target = patrol_points[patrol_index]
			velo = (target - body.position).normalized() * move_speed
			velo = body.move_and_slide(velo)
			# Turn around sprite of enemies walking backwards
			if(velo.x * sprite.scale.x < 0):
				sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)

func set_first_patrol_index(body):
	var closest_point = get_node(flight_path).curve.get_closest_point(body.position)
	var closest_distance = INF
	for i in range(0, patrol_points.size()):
		if (closest_point - patrol_points[i]).length() < closest_distance:
			patrol_index = i
			closest_distance = (closest_point - patrol_points[i]).length()

func get_direction() -> Vector2:
	return Vector2(direction, 0)

func respawn(pos):
	.respawn(pos)
	patrol_index = -1
