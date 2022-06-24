extends CPUParticles2D

onready var ball = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export(NodePath) var screen = ""
onready var tween = $Tween
func create():
	var screen_node : Label = get_node(screen)
	$AnimationTree['parameters/playback'].travel('growing')
	tween.interpolate_method(screen_node, "set_amount", 19, 0, 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func split():
	var targets = get_tree().get_nodes_in_group("timepiece_holder")
	for target in targets:
		var newPiece = preload("res://cutscenes/TimePieceBall/TimePiece.tscn").instance()
		newPiece.position = position + ball.position
		newPiece.set_goal_node(target)
		get_parent().add_child(newPiece)
	visible = false

func move_to(node_path):
	tween.interpolate_property(self, "position", self.position, get_node(node_path).position, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
