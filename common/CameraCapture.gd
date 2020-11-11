extends Node2D

export(NodePath) var camera = "../Camera"
onready var cameraObj = get_node(camera)
onready var screen_radius = get_node("CollisionShape2D").shape.extents

func _ready():
	var window_size = get_viewport().size
	print(window_size)

func capture_camera(body):
	if body.is_in_group("player"):
		cameraObj.room_capture(position)

func capture_release():
		cameraObj.capture_release()
