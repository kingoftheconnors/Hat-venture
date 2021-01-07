# Game's main camera. Follows player node throughout the level.
#
# REQUIREMENT: Must be direct child of a "level" script, which
# it needs to get the level bounds.
extends Camera2D

## Object that the camera follows
onready var target = $"../Player"
## Default smoothing for when the smoothing (panning) speed
## is decreased
onready var default_smoothing = smoothing_speed
## Smoothing speed for panning into a camera capture
const SLOW_SMOOTHING = 2
## Panning target when camera is locked to a position
## (is set to Vector2.ZERO when not used)
var target_spot : Vector2

## Wall on left side of level. Moves when level limits move
onready var left_body = $LeftBody
## Wall on right side of level. Moves when level limits move
onready var right_body = $RightBody

# Called when the node enters the scene tree for the first time.
func _ready():
	var level = $".."
	limit_top = level.up
	limit_bottom = level.down
	limit_left = level.left
	limit_right = level.right

# Called every frame to update camera position
func _process(delta):
	# Moving to a target-set position
	if target_spot != Vector2.ZERO:
		var prev_left = limit_left; var prev_right = limit_right;
		var prev_top = limit_top; var prev_bottom = limit_bottom
		# Limits are changed to force player to stay near target_spot
		limit_left = min(get_camera_screen_center().x-Constants.camera_radius.x, position.x-Constants.camera_radius.x)
		limit_right = max(get_camera_screen_center().x+Constants.camera_radius.x, position.x+Constants.camera_radius.x)
		limit_top = min(get_camera_screen_center().y-Constants.camera_radius.y, position.y-Constants.camera_radius.y)
		limit_bottom = max(get_camera_screen_center().y+Constants.camera_radius.y, position.y+Constants.camera_radius.y)
		if prev_left != limit_left or prev_right != limit_right \
			or prev_bottom != limit_bottom or prev_top != limit_top:
			left_body.set_collision_mask_bit(0, false)
			right_body.set_collision_mask_bit(0, false)
		else:
			left_body.set_collision_mask_bit(0, true)
			right_body.set_collision_mask_bit(0, true)
	else:
		# Default behavior: move to player object
		position = target.position
	# Moving left and right walls when limit moves
	if left_body.global_position.x != limit_left - 10:
		left_body.global_position.x = limit_left - 10
	if right_body.global_position.x != limit_right + 10:
		right_body.global_position.x = limit_right + 10

## Overrides target player behavior with a set screen position
func room_capture(spot):
	target_spot = spot
	position = target_spot
	smoothing_speed = SLOW_SMOOTHING

## Releases room capture and resets camera to following the player
func capture_release(spot):
	target_spot = Vector2.ZERO
	smoothing_speed = default_smoothing
