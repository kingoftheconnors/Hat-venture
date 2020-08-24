extends Camera2D

onready var target = get_node("../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	var level = get_node("..")
	limit_bottom = level.down
	limit_top = level.up
	limit_left = level.left
	limit_right = level.right

func _process(delta):
	position = target.position
