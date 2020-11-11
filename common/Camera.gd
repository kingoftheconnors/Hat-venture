extends Camera2D

onready var target = get_node("../Player")
onready var default_smoothing = smoothing_speed
const SLOW_SMOOTHING = 2

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
		limit_left = min(get_camera_screen_center().x-Constants.camera_radius.x, position.x-Constants.camera_radius.x)
		limit_right = max(get_camera_screen_center().x+Constants.camera_radius.x, position.x+Constants.camera_radius.x)
		limit_top = min(get_camera_screen_center().y-Constants.camera_radius.y, position.y-Constants.camera_radius.y)
		limit_bottom = max(get_camera_screen_center().y+Constants.camera_radius.y, position.y+Constants.camera_radius.y)
	else:
		position = target.position

func room_capture(spot):
	target_spot = spot
	position = target_spot
	smoothing_speed = SLOW_SMOOTHING

func capture_release(spot):
	target_spot = Vector2.ZERO
	smoothing_speed = default_smoothing
