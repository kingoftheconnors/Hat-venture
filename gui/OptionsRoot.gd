extends CanvasLayer

func add_palette(palette_name):
	$NinePatchRect/PaletteController.add_palette(palette_name)
	$NinePatchRect.save()

func set_openable(flag):
	$NinePatchRect.set_openable(flag)

func get_keyname(key) -> String:
	return $ControlsMenu.get_keyname(key)
