# Camera capture area. When capture_camera is called, the screen
# is centered on the position of this script's node
extends Node2D

## Path to this level's camera
export(NodePath) var camera = "../Camera"
## If true, this camera capture will be released when the player leaves the area
export(bool) var release_on_exit = true
## If true, this camera capture will be released when the player leaves the area
export(bool) var walled = true
## When level starts, gets the camera
onready var cameraObj = get_node(camera)
## Size of screen that the player is allowed to adventure around
onready var screen_radius = $CollisionShape2D.shape.extents

## Captures the camera
func capture_camera(body):
	if body.is_in_group("player"):
		cameraObj.room_capture(position, walled)

## Releases the camera to follow the player again
func capture_release():
	cameraObj.capture_release(position)


func _on_CameraCapture_body_exited(body):
	if body.is_in_group("player") and release_on_exit:
		capture_release()
