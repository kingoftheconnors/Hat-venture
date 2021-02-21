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
const SLOW_SMOOTHING = 1
## Panning target when camera is locked to a position
## (is set to Vector2.ZERO when not used)
var target_spot : Vector2

## Flag for moving left and right bodies when captured
var move_walls := true
## Wall on left side of level. Moves when level limits move
onready var left_body = $LeftBody
## Wall on right side of level. Moves when level limits move
onready var right_body = $RightBody

onready var level = $".."

## Smooth Limits (ignore regular limit system for more natural version)
var lim_top = -100
var lim_bottom = 100
var lim_left = -100
var lim_right = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_limits()

# Called every frame to update camera position
func _process(delta):
	# Moving to a target-set position
	if move_walls:
		if target_spot != Vector2.ZERO:
			var prev_left = lim_left; var prev_right = lim_right
			# Limits are changed to force player to stay near target_spot
			lim_left = min(get_camera_screen_center().x-Constants.camera_radius.x, position.x-Constants.camera_radius.x)
			lim_right = max(get_camera_screen_center().x+Constants.camera_radius.x, position.x+Constants.camera_radius.x)
			if prev_left != lim_left or prev_right != lim_right:
				left_body.set_collision_mask_bit(0, false)
				right_body.set_collision_mask_bit(0, false)
			else:
				left_body.set_collision_mask_bit(0, true)
				right_body.set_collision_mask_bit(0, true)
		else:
			# Default behavior: move to player object
			position = target.position
		# Enforce limits
		if position.y > lim_bottom - Constants.camera_radius.y:
			position.y = lim_bottom - Constants.camera_radius.y
		if position.y < lim_top + Constants.camera_radius.y:
			position.y = lim_top + Constants.camera_radius.y
		if position.x > lim_right - Constants.camera_radius.x:
			position.x = lim_right - Constants.camera_radius.x
		if position.x < lim_left + Constants.camera_radius.x:
			position.x = lim_left + Constants.camera_radius.x
		# Moving left and right walls when limit moves
		if left_body.global_position.x != lim_left - 10:
			left_body.global_position.x = lim_left - 10
		if right_body.global_position.x != lim_right + 10:
			right_body.global_position.x = lim_right + 10

onready var tween = $Tween
## Overrides target player behavior with a set screen position
func room_capture(spot, is_move_walls):
	if target_spot != spot:
		move_walls = is_move_walls
		target_spot = spot
		tween.stop_all()
		tween.interpolate_property(self, "position", self.position, spot, .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		lim_bottom = spot.y + Constants.camera_radius.y + Constants.camera_radius.y * drag_margin_bottom
		get_tree().paused = true
		yield(get_tree().create_timer(1), "timeout")
		get_tree().paused = false

## Releases room capture and resets camera to following the player
func capture_release():
	if target_spot != Vector2.ZERO:
		move_walls = true
		tween.stop_all()
		if target_spot.x < level.left:
			target_spot.x = level.left + get_viewport().get_visible_rect().size.x/2
			target_spot.y = target.position.y
		if target_spot.x > level.right:
			target_spot.x = level.right - get_viewport().get_visible_rect().size.x/2
			target_spot.y = target.position.y
		if target_spot.y < level.up:
			target_spot.x = target.position.x
			target_spot.y = level.up + get_viewport().get_visible_rect().size.y/2
		if target_spot.y > level.down:
			target_spot.x = target.position.x
			target_spot.y = level.down - get_viewport().get_visible_rect().size.y/2
		tween.interpolate_property(self, "position", self.position, target_spot, .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		get_tree().paused = true
		yield(get_tree().create_timer(1), "timeout")
		get_tree().paused = false
		target_spot = Vector2.ZERO
		reset_limits()

func reset_limits():
	lim_top = level.up - Constants.camera_radius.y * drag_margin_top
	lim_bottom = level.down + Constants.camera_radius.y * drag_margin_bottom
	lim_left = level.left - Constants.camera_radius.x * drag_margin_left
	lim_right = level.right + Constants.camera_radius.y * drag_margin_right
