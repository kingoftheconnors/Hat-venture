tool
extends Node2D

export(int) var left = -32
export(int) var right = 32
var prev_left = 0
var prev_right = 0

func _process(_delta):
	if prev_left != left or prev_right != right:
		update()
		prev_left = left
		prev_right = right

var apples_to_generate : int = 0
func generate_apples(amount : int):
	apples_to_generate = amount
	generate()

func generate():
	var apple = preload("res://enemy/RoboKurt/Apple.tscn").instance()
	apple.position.x = randi() % (right - left) + left
	add_child(apple)
	apples_to_generate -= 1
	if apples_to_generate > 0:
		$Timer.start()

# Called when the node enters the scene tree for the first time.
func _draw():
	if not Engine.editor_hint:
		return
	draw_line(Vector2(left, -10), Vector2(left, 10), Color(1, 0, 0), 5)
	draw_line(Vector2(right, -10), Vector2(right, 10), Color(1, 0, 0), 5)

func _ready():
	randomize()
