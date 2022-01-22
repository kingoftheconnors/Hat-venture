extends Control

export(NodePath) var first_item
export(bool) var pause_game_on_open = true
export(bool) var delete_on_close = true

func open():
	if pause_game_on_open:
		get_tree().paused = true
	visible = true
	get_node(first_item).grab_focus()

func _on_Close_pressed() -> void:
	close()

func _unhandled_input(event):
	if event.is_action_pressed("ui_menu") and (visible or delete_on_close):
		close()

func close():
	if pause_game_on_open:
		get_tree().paused = false
	if delete_on_close:
		queue_free()
	else:
		visible = false
	emit_signal("close")

signal close
