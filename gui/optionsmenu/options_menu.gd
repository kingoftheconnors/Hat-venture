extends menu

export(bool) var pause_game_on_open = true
export(bool) var delete_on_close = true

func open(skip_opening = false):
	.open(skip_opening)
	if pause_game_on_open:
		get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_menu") and (visible or delete_on_close):
		close()

func close(force_end = false):
	.close(force_end)
	if pause_game_on_open:
		get_tree().paused = false
	if delete_on_close:
		queue_free()

