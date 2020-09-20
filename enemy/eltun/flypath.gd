class_name flypath

var frozen = false
var velo = Vector2()
var move_speed = 30
var direction = Vector2(1, 0)

var flight_path : NodePath
var patrol_points : Array = []
var patrol_index = 0

func _init(_direction):
	direction = _direction.x

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	print("Frame! ", frozen)
	if !frozen:
		print("Path: ", flight_path)
		if !flight_path:
			return
		if patrol_points.size() == 0:
			patrol_points = body.get_node(flight_path).curve.get_baked_points()
		var target = patrol_points[patrol_index]
		if body.position.distance_to(target) < 1:
			patrol_index = wrapi(patrol_index + direction, 0, patrol_points.size())
			target = patrol_points[patrol_index]
		velo = (target - body.position).normalized() * move_speed
		velo = body.move_and_slide(velo)

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
		"type": TYPE_NODE_PATH
	}]
	return property_list

func get_property(property):
	if property == "movement/path":
		return flight_path # One can implement custom getter logic here

func set_property(property, value):
	if property == "movement/path":
		flight_path = value # One can implement custom setter logic here
		return true
	return false
