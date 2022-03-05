extends Sprite

export(NodePath) var copy_target = "."
onready var copy : Sprite = get_node(copy_target)

func _process(_delta):
	texture = copy.texture
	frame = copy.frame
	hframes = copy.hframes
	vframes = copy.vframes
