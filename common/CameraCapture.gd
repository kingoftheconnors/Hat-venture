# Camera capture area. When capture_camera is called, the screen
# is centered on the position of this script's node
extends Node2D

## Path to this level's camera
export(NodePath) var camera = "../Camera"
## When level starts, gets the camera
onready var cameraObj = get_node(camera)
## Size of screen that the player is allowed to adventure around
onready var screen_radius = $CollisionShape2D.shape.extents

## Captures the camera
func capture_camera(body):
	if body.is_in_group("player"):
		cameraObj.room_capture(position)

## Releases the camera to follow the player again
func capture_release():
		cameraObj.capture_release()
