class_name flypath

var velo = Vector2(40, 0)
var direction = Vector2()
var frozen = false
var pathToCurve = ""

# call once when node selected 
func _get_property_list():
	var property_list = []
	property_list.append({
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "movement/path",
		"type": TYPE_NODE_PATH
	})
	return property_list

func _get(property):
	if property == "movement/path":
		return pathToCurve # One can implement custom getter logic here

func _set(property, value):
	if property == "movement/path":
		pathToCurve = value # One can implement custom setter logic here
		return true

func _init(_direction):
	velo = velo * _direction
	direction = _direction

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	if !frozen:
		pass

func smash_death():
	frozen = true

func get_direction():
	return direction
