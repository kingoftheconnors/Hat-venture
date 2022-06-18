extends CPUParticles2D

onready var ball = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create():
	$AnimationTree['parameters/playback'].travel('growing')

func split():
	var targets = get_tree().get_nodes_in_group("timepiece_holder")
	for target in targets:
		var newPiece = preload("res://cutscenes/TimePieceBall/TimePiece.tscn").instance()
		newPiece.position = position + ball.position
		newPiece.set_goal_node(target)
		get_parent().add_child(newPiece)
	visible = false
