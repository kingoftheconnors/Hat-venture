extends CanvasLayer

func add_palette(palette_name):
	$NinePatchRect/PaletteController.add_palette(palette_name)
	$NinePatchRect.save()

func set_openable(flag):
	$NinePatchRect.set_openable(flag)
