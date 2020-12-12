class_name flystraight

var velo = Vector2(40, 40)
var direction = Vector2()
var frozen = false

func _init(_direction, export_dict):
	velo = velo * _direction
	direction = _direction

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Turn around
		if body.is_on_wall():
			direction.x = -direction.x
			velo = Vector2(-velo.x, velo.y)
		if body.is_on_floor():
			direction.y = -direction.y
			velo = Vector2(velo.x, -velo.y)
		elif body.is_on_ceiling():
			direction.y = -direction.y
			velo = Vector2(velo.x, -velo.y)
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

# reference methods for editor accessing flightPath
func get_script_export_list():
	return []
