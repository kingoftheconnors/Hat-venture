tool
extends Node2D

export(int) var left = 32
export(int) var right = 32
export(int) var up = 32
export(int) var down = 32
export(Color, RGB) var col
export(int) var stageNum = 1

var prev_left = 0
var prev_right = 0
var prev_up = 0
var prev_down = 0

# GIF recording software
var gifexporter = preload("res://gdgifexporter/gifexporter.gd")
var exporter = null
# load and initialize quantization method that you want to use
var quantization = preload("res://gdgifexporter/quantization/enhanced_uniform_quantization.gd").new()
var saving_gif := false
var pics = []
const FRAME_LENGTH = .08
const GIF_WIDTH = 440
const GIF_HEIGHT = 352
var gif_threads := []
var gif_frames := []

# Potentially use tilemap's get_used_rect instead for getting map size!
#var map_limits = $TileMap.get_used_rect()
#var map_cellsize = $TileMap.cell_size
#$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
#$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
#$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
#$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func _ready():
	if !Engine.is_editor_hint():
		VisualServer.set_default_clear_color(col)
		Gui.start(stageNum)

var time_passed := 0.0
func _process(_delta):
	if prev_left != left or prev_right != right \
		or prev_up != up or prev_down != down:
		update()
		prev_left = left
		prev_right = right
		prev_up = up
		prev_down = down

func _physics_process(delta):
	if !Engine.is_editor_hint():
		time_passed += delta
		if Constants.DEBUG_MODE and time_passed > FRAME_LENGTH and !saving_gif:
			# write image using quantization quantizator and with one second animation delay
			pics.append(get_viewport().get_texture().get_data())
			if pics.size() > 5/FRAME_LENGTH:
				pics.pop_front()
			time_passed -= FRAME_LENGTH
		# Cleaning save-gif threads
		if Constants.DEBUG_MODE and gif_threads.size() > 0 and !saving_gif:
			join_threads()

func _unhandled_input(event):
	if Constants.DEBUG_MODE:
		if event is InputEventKey and event.pressed and event.scancode == KEY_BACKSPACE:
			var success = get_tree().reload_current_scene()
			if success != OK:
				print("ERROR: Reloading current scene failed: ", success, ". level - _unhandled_input")
		
		if event is InputEventKey and event.pressed and event.scancode == KEY_E:
			for thread_num in range(0, gif_threads.size()):
				if gif_threads[thread_num] is Thread:
					print(thread_num, ": ", gif_threads[thread_num].is_active())
				else:
					print(thread_num, ": ", "Not a thread")
		
		if event is InputEventKey and event.pressed and event.scancode == KEY_F12 and !saving_gif:
			if pics.size() > 10:
				for img in pics:
					img.flip_x()
					img.crop(img.get_width() - (img.get_width()-GIF_WIDTH)/2, img.get_height() - (img.get_height()-GIF_HEIGHT)/2)
					img.flip_x(); img.flip_y()
					img.crop(GIF_WIDTH, GIF_HEIGHT)
					img.convert(Image.FORMAT_RGBA8)
				saving_gif = true
				exporter = gifexporter.new(GIF_WIDTH, GIF_HEIGHT)
				gif_threads = []; gif_frames = []
				# Make one thread for each frame we need to generate
				# We're not including the last five frames
				for thread_num in range(pics.size()-10):
					gif_threads.append(Thread.new())
					gif_frames.append(null)
					gif_threads[thread_num].start(self, "create_gif", thread_num, Thread.PRIORITY_LOW)

func create_gif(thread_num : int):
	gif_frames[thread_num] = exporter.create_frame(pics[thread_num], FRAME_LENGTH)
	# when you have exported all frames of animation, then you can save data into file
	# Only the first thread is responsible for saving
	if thread_num == 0:
		# Wait for all other threads to save their frames
		for thread_num in range(1, gif_threads.size()):
			if gif_threads[thread_num] is Thread \
				and gif_threads[thread_num].is_active():
				gif_threads[thread_num].wait_to_finish()
		for frame in gif_frames:
			if frame != null:
				exporter.add_frame(frame)
		var file: File = File.new()
		# open new file with write privlige
		var _success = file.open('res://gifs/' + str(OS.get_unix_time()) + '.gif', File.WRITE)
		if _success != OK:
			print("ERROR: Cannot open file in create_gif(). Check if 'gifs' file exists in Hat-Venture directory")
		# save data stream into file
		file.store_buffer(exporter.export_file_data())
		file.close()
		saving_gif = false
		pics = []
		print("Gif saved!")

func join_threads():
	print("Joining!")
	for thread in gif_threads:
		print(thread)
		if thread is Thread and thread.is_active():
			print("Joining")
			thread.wait_to_finish()
	gif_threads = []; gif_frames = []

# Called when the node enters the scene tree for the first time.
func _draw():
	if not Engine.editor_hint:
		return
	
	draw_line(Vector2(left, up-160), Vector2(left, down+160), Color(1, 0, 0), 5)
	draw_line(Vector2(right, up-160), Vector2(right, down+160), Color(1, 0, 0), 5)
	draw_line(Vector2(left-160, up), Vector2(right+160, up), Color(1, 0, 0), 5)
	draw_line(Vector2(left-160, down), Vector2(right+160, down), Color(1, 0, 0), 5)

# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
	for thread in gif_threads:
		if thread is Thread and thread.is_active():
			thread.wait_to_finish()
