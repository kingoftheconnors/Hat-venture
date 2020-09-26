extends Resource
class_name blastDying

var velo = Vector2(40, -200)

func _init(direction, export_dict):
	velo.x = velo.x * -direction.x

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	var retVelo = body.move_and_slide(velo, Vector2.UP)
	# Gravity
	velo.y = retVelo.y + Constants.gravity
	if body.is_on_wall():
		velo = Vector2(-velo.x, velo.y)

# reference methods for editor accessing flightPath
func get_script_export_list():
	return []
