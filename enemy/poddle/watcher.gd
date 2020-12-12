class_name shooter

const ENEMY_GRAVITY = 9
var direction = Vector2()
var velo = Vector2(0, 0)
var frozen = false
var shoot_time = 0
var is_turning = false

const BASE_SPEED = 5.0

func _init(_direction, export_dict):
	direction = _direction
	update_exports(export_dict)

func update_exports(export_dict):
	is_turning = export_dict.get('movement/is_turning', false)

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Gravity
		velo.y = retVelo.y + ENEMY_GRAVITY
		if direction.x * sprite.scale.x < 0:
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
		# Turn to player
		if is_turning:
			var player_nodes = body.get_tree().get_nodes_in_group("player_root")
			if player_nodes.size() > 0:
				if player_nodes[0].global_position.x > body.global_position.x and direction.x < 0:
					direction.x = -direction.x
				elif player_nodes[0].global_position.x < body.global_position.x and direction.x > 0:
					direction.x = -direction.x

func smash_death():
	frozen = true

func get_direction():
	return direction

# reference methods for editor accessing turnaround time
func get_script_export_list():
	var property_list = [{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "movement/is_turning",
		"type": TYPE_BOOL,
		"default": false
	}]
	return property_list
