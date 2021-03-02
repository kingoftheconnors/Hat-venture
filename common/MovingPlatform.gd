extends Path2D

# Frame process function. Moves platform.
func _physics_process(delta):
	if is_active:
		# Set patrol baked points
		if patrol_points.size() == 0:
			patrol_points = curve.get_baked_points()
		# Set first frame position
		if patrol_index < 0:
			set_first_patrol_index()
		else:
			var target = patrol_points[patrol_index]
			if platform.position.distance_to(target) < 1:
				patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
				target = patrol_points[patrol_index]
			velo = (target - platform.position).normalized() * move_speed
			platform.position += velo*delta

func set_first_patrol_index():
	var closest_point = curve.get_closest_point(platform.position)
	var closest_distance = INF
	for i in range(0, patrol_points.size()):
		if (closest_point - patrol_points[i]).length() < closest_distance:
			patrol_index = i
			closest_distance = (closest_point - patrol_points[i]).length()

onready var platform = $PlatformBody

var velo = Vector2()
## Platform speed
export(int) var move_speed = 60
var patrol_points : Array = []
var patrol_index = -1
var is_active = false

func set_active():
	is_active = true
