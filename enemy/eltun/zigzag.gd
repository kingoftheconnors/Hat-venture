class_name zigzag

var velo = Vector2(40, 80)
var DASH_FORCE = Vector2(40,80)
var DASH_FRICTION = 0.985
var DASH_TRESHHOLD = 30
var direction = Vector2()
var frozen = false

func _init(_direction, export_dict):
	velo = DASH_FORCE * _direction
	direction = _direction

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Zigzag
		velo *= DASH_FRICTION
		if abs(velo.y) <= DASH_TRESHHOLD:
			direction.y = -direction.y
			velo = direction * DASH_FORCE
		# Turn around
		if body.is_on_wall():
			direction.x = -direction.x
			velo = Vector2(-velo.x, velo.y)
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
