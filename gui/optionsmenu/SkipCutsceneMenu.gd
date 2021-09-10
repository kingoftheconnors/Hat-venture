extends Control

signal skip_cutscene

export(NodePath) var first_item

# You can use 'grab_focus()' to focus on the first element of the menu
func _ready() -> void:
	get_node(first_item).grab_focus()

func _on_Close_pressed() -> void:
	close()

func _on_Confirm_pressed():
	emit_signal("skip_cutscene")
	close()

func _unhandled_input(event):
	if event.is_action_pressed("ui_menu"):
		close()

func close():
	queue_free()
