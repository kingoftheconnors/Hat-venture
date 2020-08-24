extends Node2D

export(NodePath) var playerPath
onready var player = get_node(playerPath)

# Called when the node enters the scene tree for the first time.
func _ready():
	player.set_spawn(position)
