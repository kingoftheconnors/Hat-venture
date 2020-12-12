class_name lemming

const ENEMY_GRAVITY = 9
const DEFAULT_TURNAROUND_OFFSET = 8
var velo = Vector2(30, 0)
var direction = Vector2()
var frozen = false

var floorchecker : NodePath
var floorchecker_obj : RayCast2D
var turnaround_offset : int

func _init(_direction, export_dict):
	velo.x = velo.x * _direction.x
	direction = _direction

func update_exports(export_dict):
	floorchecker = export_dict.get('movement/floorchecker', null)
	turnaround_offset = export_dict.get('movement/turnaround_offset', DEFAULT_TURNAROUND_OFFSET)

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	# Get raycast
	if floorchecker and floorchecker_obj == null:
		floorchecker_obj = body.get_node(floorchecker)
		floorchecker_obj.position.x = turnaround_offset * direction.x
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Gravity
		velo.y = retVelo.y + ENEMY_GRAVITY
		# Turning around
		if body.is_on_wall() or \
			(body.is_on_floor() and floorchecker_obj \
				and not floorchecker_obj.is_colliding()):
			velo = Vector2(-velo.x, velo.y)
			direction.x = -direction.x
			# Move floor_checker
			if floorchecker_obj:
				floorchecker_obj.position.x = turnaround_offset * direction.x
		# Turn around sprite of enemies walking backwards
		if(direction.x * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)

func smash_death():
	frozen = true

func get_direction():
	return direction

# reference methods for editor accessing flightPath
func get_script_export_list():
	var property_list = [{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "movement/floorchecker",
		"type": TYPE_NODE_PATH,
		"default": null
	},
	{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "movement/turnaround_offset",
		"type": TYPE_INT,
		"default": DEFAULT_TURNAROUND_OFFSET
	}]
	return property_list
