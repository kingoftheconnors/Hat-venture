extends NinePatchRect

func show_palette_get(palette_name):
	$PaletteName.text = palette_name
	$AnimationTree['parameters/playback'].travel("enter")
