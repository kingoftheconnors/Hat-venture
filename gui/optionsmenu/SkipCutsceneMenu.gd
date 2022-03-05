extends Control

signal skip_cutscene

export(NodePath) var first_item

func open():
	get_node(first_item).grab_focus()
	Gui.claim_menu_space()

func _on_Close_pressed() -> void:
	close()

func _on_Confirm_pressed():
	emit_signal("skip_cutscene")
	close()

func _unhandled_input(event):
	if event.is_action_pressed("ui_menu"):
		close()

func close():
	Gui.release_menu_space()
	queue_free()
