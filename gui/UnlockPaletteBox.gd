extends NinePatchRect

func show_palette_get(palette_name):
	$Dialog.text = "New Palette Unlocked"
	$PaletteName.text = palette_name
	$Dialog2.text = "Added to the pause menu"
	$AnimationTree['parameters/playback'].travel("enter")
func show_storybook_get(num_pages : int):
	$Dialog.text = "New Storybook Page Found"
	$PaletteName.text = str(num_pages) + "/0"
	$Dialog2.text = "There is no Gallery... YET"
	$AnimationTree['parameters/playback'].travel("enter")
