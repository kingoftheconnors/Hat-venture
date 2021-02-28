extends KinematicBody2D

const ENEMY_GRAVITY = 9
export(float) var gravityMultiplier = 0
export(bool) var is_despawn = false
onready var animator = get_node_or_null("AnimationPlayer")

var velo = Vector2(0, -110)

func _physics_process(_delta):
	velo.y += ENEMY_GRAVITY * gravityMultiplier
	# terminal velocity
	if velo.y > Constants.terminalVelocity:
		velo.y = Constants.terminalVelocity
	velo = move_and_slide_with_snap(velo, Vector2.DOWN, Vector2.UP)
	if is_on_floor():
		velo.x *= 0.93
	# Despawning objects will die on hitting a brick
	if is_despawn:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.travel.y > 0.1:
				if animator:
					animator.play("fade")
				$Sprite.speed_scale = .75 + randf()*1.5
