tool
extends Resource
class_name pace

var velo = Vector2(40, 40)
var DASH_FORCE = Vector2(40,40)
var direction = Vector2()
var frozen = false
var frame = 0

const DEFAULT_TURNAROUND_TIME = 100
var turnaround_time

func _init(_direction, export_dict):
	velo = DASH_FORCE * _direction
	direction = _direction
	update_exports(export_dict)

func update_exports(export_dict):
	turnaround_time = export_dict.get('movement/turnaround_time', 100)

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	if !frozen:
		velo = body.move_and_slide(velo, Vector2.UP)
		# Zigzag
		frame += 1
		if frame > turnaround_time:
			direction = -direction
			velo = direction * DASH_FORCE
			frame = 0
		# Turn around
		if body.is_on_wall():
			direction.x = -direction.x
			velo = Vector2(-velo.x, velo.y)
			frame = turnaround_time - frame
		if body.is_on_floor() or body.is_on_ceiling():
			direction.y = -direction.y
			velo = direction * DASH_FORCE
			frame = turnaround_time - frame
		# Turn around sprite of enemies walking backwards
		if(velo.x * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
			if sprite.scale.x > 0:
				direction.x = 1
			else:
				direction.x = -1

func smash_death():
	frozen = true

func get_direction():
	return direction

# reference methods for editor accessing turnaround time
func get_script_export_list():
	var property_list = [{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "movement/turnaround_time",
		"type": TYPE_INT,
		"default": DEFAULT_TURNAROUND_TIME
	}]
	return property_list

