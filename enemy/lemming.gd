extends KinematicBody2D

export(Vector2) var velo = Vector2(1, 0)
onready var sprite = get_node("EnemyCore")

# Called when the node enters the scene tree for the first time.
func _process(delta):
	var retVelo = move_and_slide(velo, Vector2.UP)
	# Gravity
	velo.y = retVelo.y + Constants.gravity
	if is_on_wall():
		velo = Vector2(-velo.x, velo.y)
	# Turn around sprite of enemies walking backwards
	if(velo.x * sprite.scale.x < 0):
		sprite.scale = Vector2(-sprite.scale.x, sprite.scale.y)
