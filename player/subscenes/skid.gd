extends AnimatedSprite

const SPEED = 3
var velo = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	playing = true

func init(direc):
	scale.x = -direc
	velo.x = -direc * SPEED

func _physics_process(delta):
	position += velo * SPEED * delta

func _on_AnimatedSprite_animation_finished():
	queue_free()
