tool
extends Resource
class_name flypath

var frozen = false
var velo = Vector2()
var move_speed = 60
var direction = Vector2(1, 0)

var flight_path : NodePath
var patrol_points : Array = []
var patrol_index = -1

func _init(_direction, export_dict):
	direction = _direction.x
	update_exports(export_dict)

func update_exports(export_dict):
	flight_path = export_dict.get('movement/path', '.')

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	# Set patrol baked points
	if !flight_path.is_empty() and flight_path.get_name_count() > 0:
		if patrol_points.size() == 0:
			patrol_points = body.get_node(flight_path).curve.get_baked_points()
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
	var closest_point = body.get_node(flight_path).curve.get_closest_point(body.position)
	var closest_distance = INF
	for i in range(0, patrol_points.size()):
		if (closest_point - patrol_points[i]).length() < closest_distance:
			patrol_index = i
			closest_distance = (closest_point - patrol_points[i]).length()

func smash_death():
	frozen = true

func get_direction():
	return direction

# reference methods for editor accessing flightPath
func get_script_export_list():
	var property_list = [{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "movement/path",
		"type": TYPE_NODE_PATH,
		"default": "."
	}]
	return property_list
