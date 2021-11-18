# Game's main camera. Follows player node throughout the level.
#
# REQUIREMENT: Must be direct child of a "level" script, which
# it uses to get the level bounds.
extends Camera2D

## Object that the camera follows
onready var target = $"../Player"
## Default smoothing for when the smoothing (panning) speed
## is decreased
onready var default_smoothing = smoothing_speed
## Smoothing speed for panning into a camera capture
const SLOW_SMOOTHING = .25
const SMOOTHING_EQUILIBRUM_RATE : float = 4.0
## Panning target when camera is locked to a position
## (is set to Vector2.ZERO when not used)
var target_spot : Vector2
## Lookahead amount for when the target is moving fast,
## so the camera can still catch incoming objects
var lookahead_offset : float
const LOOKAHEAD_CHANGE_RATE = 30

## Flag for moving left and right bodies when captured
var move_walls := true
## Wall on left side of level. Moves when level limits move
onready var left_body = $LeftBody
onready var left_collider = $LeftBody/CollisionShape2D
## Wall on right side of level. Moves when level limits move
onready var right_body = $RightBody
onready var right_collider = $RightBody/CollisionShape2D

onready var level = $".."

onready var timer = $Timer

## Smooth Limits (ignore regular limit system for more natural version)
var lim_top = -100
var lim_bottom = 100
var lim_left = -100
var lim_right = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	reset_limits()

# Called every frame to update camera position
func _physics_process(delta):
	# Moving to a target-set position
	if move_walls:
		if target_spot != Vector2.ZERO:
			var prev_left = lim_left; var prev_right = lim_right
			# Limits are changed to force player to stay near target_spot
			lim_left = min(get_camera_screen_center().x-(Gui.get_screen_resolution().x/2), position.x-(Gui.get_screen_resolution().x/2))
			lim_right = max(get_camera_screen_center().x+(Gui.get_screen_resolution().x/2), position.x+(Gui.get_screen_resolution().x/2))
			if prev_left != lim_left or prev_right != lim_right:
				left_body.set_collision_mask_bit(0, false)
				right_body.set_collision_mask_bit(0, false)
			else:
				left_body.set_collision_mask_bit(0, true)
				right_body.set_collision_mask_bit(0, true)
		else:
			# Default behavior: move to player object
			position = target.position + Vector2(lookahead_offset, 0)
		# Enforce limits
		if position.y > lim_bottom - Gui.get_screen_resolution().y/2:
			position.y = lim_bottom - Gui.get_screen_resolution().y/2
		if position.y < lim_top + Gui.get_screen_resolution().y/2:
			position.y = lim_top + Gui.get_screen_resolution().y/2
		if position.x > lim_right - (Gui.get_screen_resolution().x/2):
			position.x = lim_right - (Gui.get_screen_resolution().x/2)
		if position.x < lim_left + (Gui.get_screen_resolution().x/2):
			position.x = lim_left + (Gui.get_screen_resolution().x/2)
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
		lim_bottom = spot.y + Gui.get_screen_resolution().y/2 + (Gui.get_screen_resolution().y/2) * drag_margin_bottom
		get_tree().paused = true
		if timer.is_connected("timeout", self, "finish_capture_release"):
			timer.disconnect("timeout", self, "finish_capture_release")
		timer.connect("timeout", self, "finish_room_capture")
		timer.start()

func finish_room_capture():
	timer.disconnect("timeout", self, "finish_room_capture")
	get_tree().paused = false
	left_collider.disabled = false
	right_collider.disabled = false

## Releases room capture and resets camera to following the player
func capture_release(release_box_position):
	if target_spot != Vector2.ZERO and target_spot == release_box_position:
		move_walls = true
		tween.stop_all()
		if target_spot.x < level.left:
			target_spot.x = level.left + get_viewport().get_visible_rect().size.x/2
			target_spot.y = min(level.down - get_viewport().get_visible_rect().size.y/2, max(level.up + get_viewport().get_visible_rect().size.y/2, target.position.y))
		if target_spot.x > level.right:
			target_spot.x = level.right - get_viewport().get_visible_rect().size.x/2
			target_spot.y = min(level.down - get_viewport().get_visible_rect().size.y/2, max(level.up + get_viewport().get_visible_rect().size.y/2, target.position.y))
		if target_spot.y < level.up:
			target_spot.x = min(level.right - get_viewport().get_visible_rect().size.x/2, max(level.left + get_viewport().get_visible_rect().size.x/2, target.position.x))
			target_spot.y = level.up + get_viewport().get_visible_rect().size.y/2
		if target_spot.y > level.down:
			target_spot.x = min(level.right - get_viewport().get_visible_rect().size.x/2, max(level.left + get_viewport().get_visible_rect().size.x/2, target.position.x))
			target_spot.y = level.down - get_viewport().get_visible_rect().size.y/2
		tween.interpolate_property(self, "position", self.position, target_spot, .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		reset_limits()
		get_tree().paused = true
		if timer.is_connected("timeout", self, "finish_room_capture"):
			timer.disconnect("timeout", self, "finish_room_capture")
		timer.connect("timeout", self, "finish_capture_release")
		timer.start()

func finish_capture_release():
	get_tree().paused = false
	timer.disconnect("timeout", self, "finish_capture_release")
	target_spot = Vector2.ZERO
	reset_limits()
	left_collider.disabled = true
	right_collider.disabled = true

func reset_limits():
	lim_top = level.up - (Gui.get_screen_resolution().y/2) * drag_margin_top
	lim_bottom = level.down + (Gui.get_screen_resolution().y/2) * drag_margin_bottom
	lim_left = level.left - (Gui.get_screen_resolution().x/2) * drag_margin_left
	lim_right = level.right + (Gui.get_screen_resolution().x/2) * drag_margin_right

func move_lookahead_toward(offset_goal, delta):
	if target_spot:
		lookahead_offset = 0
		return
	# If we are turning around our offset, increase the offset change rate
	if offset_goal * lookahead_offset < 0:
		delta *= 2
	if(lookahead_offset > offset_goal):
		lookahead_offset -= LOOKAHEAD_CHANGE_RATE * delta
	elif(lookahead_offset < offset_goal):
		lookahead_offset += LOOKAHEAD_CHANGE_RATE * delta

var shake_intensity : int = 0
var shake_duration : float = 0
var shake_amount : Vector2
func shake_screen(amount : int, duration : float):
	shake_intensity = amount
	shake_duration = duration

func _process(delta):
	if shake_duration > 0.0:
		position -= shake_amount
		shake_duration -= delta
		if shake_duration > 0.0:
			var x_amo = randi() % (shake_intensity*2) - shake_intensity
			var y_amo = 0.0 #randi() % (shake_intensity*2) - shake_intensity
			shake_amount = Vector2(x_amo, y_amo)
			position += shake_amount

# Unpause game if node is destroyed in the middle of a transition
func _exit_tree():
	if timer.time_left > 0:
		get_tree().paused = false

