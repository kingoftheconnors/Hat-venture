tool
extends Resource
class_name shooter

var direction = Vector2()
var velo = Vector2(0, 0)
var frozen = false
var shoot_time = 0

const BASE_SPEED = 5.0

func _init(_direction, export_dict):
	direction = _direction

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Gravity
		velo.y = retVelo.y + Constants.gravity
		# Turn to player
		var player_nodes = body.get_tree().get_nodes_in_group("player_root")
		if player_nodes.size() > 0:
			if player_nodes[0].global_position.x > body.global_position.x and sprite.scale.x < 0:
					sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
			if player_nodes[0].global_position.x < body.global_position.x and sprite.scale.x > 0:
					sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)

func smash_death():
	frozen = true

func get_direction():
	return direction

# reference methods for editor accessing turnaround time
func get_script_export_list():
	return []
