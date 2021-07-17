# Script for using and saving changes to the options menu
extends NinePatchRect

func _unhandled_input(event):
	# Open and close menu
	if visible:
		if event.is_action_pressed("ui_menu") or event.is_action_pressed("ui_B"):
			# Close menu
			close()
			get_tree().set_input_as_handled() 

func open():
	# Open menu
	show()
	get_node(first_item).grab_focus()

func close():
	hide()
	get_node(previous_menu).reset_focus(menu_name)

func set_dirty():
	dirty = true

var dirty = false

export(NodePath) var first_item
export(NodePath) var previous_menu
export(String) var menu_name = "controls"
