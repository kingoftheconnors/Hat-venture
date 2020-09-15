class_name paraenemy

var velo = Vector2(30, 0)
var JUMP_FORCE = 200
var direction = Vector2()
var frozen = false

func _init(_direction):
	velo.x = velo.x * _direction
	direction = _direction

# Called when the node enters the scene tree for the first time.
func frame(body, sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Gravity
		velo.y = retVelo.y + Constants.gravity
		# Jumping
		if body.is_on_floor():
			velo.y = -JUMP_FORCE
		if body.is_on_wall():
			velo = Vector2(-velo.x, velo.y)
		# Turn around sprite of enemies walking backwards
		if(velo.x * sprite.scale.x < 0):
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
			if sprite.scale.x > 0:
				direction = 1
			else:
				direction = -1

func smash_death():
	frozen = true

func get_direction():
	return direction
