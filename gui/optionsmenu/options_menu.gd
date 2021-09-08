extends Control

export(NodePath) var first_item

# You can use 'grab_focus()' to focus on the first element of the menu
func _ready() -> void:
	get_tree().paused = true
	get_node(first_item).grab_focus()

func _on_Close_pressed() -> void:
	close()

func _unhandled_input(event):
	if event.is_action_pressed("ui_menu"):
		close()

func close():
	get_tree().paused = false
	queue_free()
