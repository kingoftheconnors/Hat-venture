extends Control

signal changed

# Change color to show focus
func _on_focus_entered():
	l_arrow.visible = true
	r_arrow.visible = true
func _on_focus_exited():
	l_arrow.visible = false
	r_arrow.visible = false

# Handle overridable Left and Right functions (and emit signal)
func _input(event):
	# Open and close menu
	if has_focus():
		if event.is_action_pressed("ui_left"):
			move_left()
			accept_event()
		if event.is_action_pressed("ui_right"):
			move_right()
			accept_event()

func move_left():
	palette_index = wrapi(palette_index-1, 0, usable_palettes.size())
	update_palette()
	emit_signal("changed")
func move_right():
	palette_index = wrapi(palette_index+1, 0, usable_palettes.size())
	update_palette()
	emit_signal("changed")

func update_palette():
	current_label.text = usable_palettes[palette_index]
	Gui.set_palette(usable_palettes[palette_index])

func set_usable_palettes(palettes : Array):
	if palettes.size() > 0:
		usable_palettes = palettes
func get_usable_palettes():
	return usable_palettes

func set_cur_palette(palette : String):
	var new_palette_index = usable_palettes.find(palette)
	print(new_palette_index)
	if new_palette_index >= 0:
		palette_index = new_palette_index
		update_palette()
func get_cur_palette():
	return usable_palettes[palette_index]

func add_palette(palette_name):
	usable_palettes.append(palette_name)

const DEFAULT_PALETTES : Array = ["Classic", "Muted"]
var usable_palettes : Array = DEFAULT_PALETTES
var palette_index = 0
onready var l_arrow : Label = $L
onready var r_arrow : Label = $R
onready var current_label : Label = $Current
