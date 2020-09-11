tool
extends Node2D

export(int) var left = 32
export(int) var right = 32
export(int) var up = 32
export(int) var down = 32
export(Color, RGB) var col

var prev_left = 0
var prev_right = 0
var prev_up = 0
var prev_down = 0

# Potentially use tilemap's get_used_rect instead for getting map size!
#var map_limits = $TileMap.get_used_rect()
#var map_cellsize = $TileMap.cell_size
#$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
#$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
#$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
#$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func _ready():
	VisualServer.set_default_clear_color(col)

func _process(_delta):
	if prev_left != left or prev_right != right \
		or prev_up != up or prev_down != down:
		update()
		prev_left = left
		prev_right = right
		prev_up = up
		prev_down = down

func _unhandled_input(event):
	if Constants.DEBUG_MODE:
		if event is InputEventKey and event.pressed and event.scancode == KEY_BACKSPACE:
			print("Resetting scene!")
			get_tree().reload_current_scene()

# Called when the node enters the scene tree for the first time.
func _draw():
	if not Engine.editor_hint:
		return
	
	draw_line(Vector2(left, up-320), Vector2(left, down+320), Color(1, 0, 0), 5)
	draw_line(Vector2(right, up-320), Vector2(right, down+320), Color(1, 0, 0), 5)
	draw_line(Vector2(left-320, up), Vector2(right+320, up), Color(1, 0, 0), 5)
	draw_line(Vector2(left-320, down), Vector2(right+320, down), Color(1, 0, 0), 5)


