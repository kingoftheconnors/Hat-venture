extends Camera2D

onready var target = get_node("../Player")
onready var default_smoothing = smoothing_speed
const SLOW_SMOOTHING = 2

onready var left_body = get_node("LeftBody")
onready var right_body = get_node("RightBody")

var target_spot : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	var level = get_node("..")
	limit_top = level.up
	limit_bottom = level.down
	limit_left = level.left
	limit_right = level.right

func _process(delta):
	if target_spot != Vector2.ZERO:
		var prev_left = limit_left; var prev_right = limit_right;
		var prev_top = limit_top; var prev_bottom = limit_bottom
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
		position = target.position
	if left_body.global_position.x != limit_left - 10:
		left_body.global_position.x = limit_left - 10
	if right_body.global_position.x != limit_right + 10:
		right_body.global_position.x = limit_right + 10

func room_capture(spot):
	target_spot = spot
	position = target_spot
	smoothing_speed = SLOW_SMOOTHING

func capture_release(spot):
	target_spot = Vector2.ZERO
	smoothing_speed = default_smoothing
