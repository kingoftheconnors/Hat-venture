tool
extends Node2D

export(int) var left = 32
export(int) var right = 32
export(int) var up = 32
export(int) var down = 32
export(Color, RGB) var col
export(int) var stageNum = 1
export(bool) var show_hud = true

var prev_left = 0
var prev_right = 0
var prev_up = 0
var prev_down = 0

func _ready():
	if !Engine.is_editor_hint():
		VisualServer.set_default_clear_color(col)
		Gui.start(stageNum)
		if not show_hud:
			Gui.call_deferred("hide")

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
			var success = get_tree().reload_current_scene()
			if success != OK:
				print("ERROR: Reloading current scene failed: ", success, ". level - _unhandled_input")

# Called when the node enters the scene tree for the first time.
func _draw():
	if not Engine.editor_hint:
		return
	
	draw_line(Vector2(left, up-160), Vector2(left, down+160), Color(1, 0, 0), 5)
	draw_line(Vector2(right, up-160), Vector2(right, down+160), Color(1, 0, 0), 5)
	draw_line(Vector2(left-160, up), Vector2(right+160, up), Color(1, 0, 0), 5)
	draw_line(Vector2(left-160, down), Vector2(right+160, down), Color(1, 0, 0), 5)
