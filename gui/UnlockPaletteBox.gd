extends NinePatchRect

# Handle overridable Left and Right functions (and emit signal)
func _input(event):
	# Change keybind
	if has_focus():
		if event.is_action_pressed("ui_A") or event.is_action_pressed("ui_accept") \
			or event.is_action_pressed("ui_B") or event.is_action_pressed("ui_cancel"):
			get_tree().paused = false
			visible = false
			$"../ExampleFilter".visible = false
			release_focus()

func set_palette(palette_name):
	$PaletteName.text = palette_name
	$"../ExampleFilter".set_palette(palette_name)
	$"../ExampleFilter".visible = true
