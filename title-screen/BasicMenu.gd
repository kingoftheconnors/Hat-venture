extends Control

export(NodePath) var first_item

export(bool) var enable_on_start = true

# You can use 'grab_focus()' to focus on the first element of the menu
func _ready() -> void:
	if enable_on_start:
		open()

func open():
	visible = true
	get_node(first_item).grab_focus()
	Gui.call_deferred("menu_opened")

func close() -> void:
	visible = false
	emit_signal("close")
	Gui.menu_closed()

signal close
