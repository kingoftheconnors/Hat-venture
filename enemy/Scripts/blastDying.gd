# Movement process script. Can be set on an enemy's
# controller_obj to override a default movement pattern.
class_name blastDying

const FALLING_BODY_GRAVITY = 11
var velo = Vector2(40, -200)

func _init(direction):
	velo.x = velo.x * -direction.x

# Frame process function. Moves body.
func frame(body, sprite, delta):
	var retVelo = body.move_and_slide(velo, Vector2.UP)
	# Gravity
	velo.y = retVelo.y + FALLING_BODY_GRAVITY
