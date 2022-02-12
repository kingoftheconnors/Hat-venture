extends CanvasLayer

"""
GifGetterUI

Single scene + script that can be dropped in and out of any scene.

Most gif-related variables are set from the LineEdit values.
"""

const MAX_CONSOLE_MESSAGE_COUNT: int = 20

onready var _viewport_rid: RID = get_viewport().get_viewport_rid()

onready var save_location_line_edit: LineEdit = $Control/Options/VBoxContainer/SaveLocationContainer/LineEdit
# Gif width (must match image data passed in)
var _width : int = 320
# Gif height (must match image data passed in)
var _height : int = 240
# Determines if viewport texture data should be stored for processing
var _should_capture: bool = false
# Holds viewport texture data
var _images: Array = []

var saving_gif := false
var pics : Array = []
# Constants
const FRAME_LENGTH = .08
const GIF_WIDTH = 208
const GIF_HEIGHT = 208

# Total number of frames in the gif
var _max_frames: int = 60
var _gif_frame_delay : int = 8

# Rendering quality for gifs from 1 - 30. 1 is highest quality but slow
var _render_quality: int = 8

# Background thread for capturing screenshots
var _capture_thread: Thread = Thread.new()
# Number of render threads
var _max_threads: int = 4

# Rust gif creation library
var _gif_handler: Reference = load("res://addons/godot-gif-getter/GifHandler.gdns").new()

var time_passed := 0.0
func _physics_process(delta: float) -> void:
	time_passed += delta
	if Constants.DEBUG_MODE and time_passed > FRAME_LENGTH:
		pics.append(get_viewport().get_texture().get_data())
		if pics.size() > 5/FRAME_LENGTH:
			pics.pop_front()
		time_passed -= FRAME_LENGTH
	if _should_capture:
		if not _capture_thread.is_active():
			_capture_thread.start(self, "_capture_frames")

func _unhandled_input(event):
		if event is InputEventKey and event.pressed and event.scancode == KEY_F12:
			if pics.size() > 10:
				for img in pics:
					img.flip_x()
					img.crop(img.get_width() - (img.get_width()-GIF_WIDTH)/2, img.get_height() - (img.get_height()-GIF_HEIGHT)/2)
					img.flip_x(); img.flip_y()
					img.crop(GIF_WIDTH, GIF_HEIGHT)
					img.convert(Image.FORMAT_RGBA8)
				capture(pics, GIF_WIDTH, GIF_HEIGHT)

func _exit_tree() -> void:
	if _capture_thread.is_active():
		_capture_thread.wait_to_finish()

###############################################################################
# Connections                                                                 #
###############################################################################

func capture(images : Array, width : int, height: int) -> void:
	_images = images
	_width = width
	_height = height
	_should_capture = true
	yield(get_tree(), "physics_frame")

###############################################################################
# Private functions                                                           #
###############################################################################

func _rust_multi_thread() -> void:
	"""
	Wrapper function for calling a Rust library to process and render a gif.
	"""
	var images_bytes: Array = []
	for image in _images:
		images_bytes.append(image.get_data())
	_gif_handler.set_file_name(str(OS.get_unix_time()) + '.gif')
	_gif_handler.set_frame_delay(_gif_frame_delay)
	_gif_handler.set_parent(self)
	_gif_handler.set_render_quality(_render_quality)
	_gif_handler.write_frames(
			images_bytes,
			_width,
			_height,
			_max_threads,
			_max_frames)

func _capture_frames(_x) -> void:
	"""
	Needs to be run on a background thread otherwise it blocks the main thread
	when saving a viewport image.
	
	_max_frames has 1 added to it since the last frame will usually have the UI
	visible in it. Instead of solving that problem, just remove the last frame.
	"""
	
	_should_capture = false
	_images.pop_back()
	
	_rust_multi_thread()

	_log_message("gif saved")

	_images.clear()
	
	_capture_thread.call_deferred("wait_to_finish")

func _log_message(message: String, is_error: bool = false) -> void:
	var label: Label = Label.new()
	if is_error:
		label.text += "[ERROR] "
	label.text += message
	print(message)
