class_name bouncy

const ENEMY_GRAVITY = 9
var velo = Vector2(40, 0)
var direction = Vector2()
var frozen = false
var frame = 0

const DEFAULT_JUMP_FORCE = 100
var jump_force

func _init(_direction, export_dict):
	direction = _direction
	update_exports(export_dict)
	velo.x = velo.x * _direction.x
	velo.y = jump_force * _direction.x

func update_exports(export_dict):
	jump_force = abs(export_dict.get('movement/jump_force', DEFAULT_JUMP_FORCE))

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		velo.y = retVelo.y + ENEMY_GRAVITY/2
		# Zigzag
		frame += 1
		if velo.y > jump_force or body.is_on_floor():
			direction.y = -direction.y
			velo.y = -jump_force * abs(direction.y)
			frame = 0
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

# reference methods for editor accessing turnaround time
func get_script_export_list():
	var property_list = [{
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"name": "movement/jump_force",
		"type": TYPE_INT,
		"default": DEFAULT_JUMP_FORCE
	}]
	return property_list

