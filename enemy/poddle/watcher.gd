extends "res://enemy/Scripts/EnemyController.gd"
class_name shooter

const ENEMY_GRAVITY = 9
export(int, -1, 1) var direction : int = 1
var velo = Vector2(0, 0)
var shoot_time = 0
export(bool) var is_turning = false

const BASE_SPEED = 5.0

# Called when the node enters the scene tree for the first time.
func frame(body : KinematicBody2D, sprite : Sprite, delta):
	if !frozen:
		var retVelo = body.move_and_slide(velo, Vector2.UP)
		# Gravity
		velo.y = retVelo.y + ENEMY_GRAVITY
		if direction * sprite.scale.x < 0:
			sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
		# Turn to player
		if is_turning:
			var player_nodes = body.get_tree().get_nodes_in_group("player_root")
			if player_nodes.size() > 0:
				if player_nodes[0].global_position.x > body.global_position.x and direction < 0:
					direction = -direction
				elif player_nodes[0].global_position.x < body.global_position.x and direction > 0:
					direction = -direction

func get_direction() -> Vector2:
	return Vector2(direction, 0)
