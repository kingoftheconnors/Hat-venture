extends NinePatchRect
class_name unlock_box

enum PALETTE_ENTER_DIRECTION {
	TOP,
	BOTTOM
}

func show_palette_get(palette_name, enter_from : int):
	$Dialog.text = "New Palette Unlocked"
	$PaletteName.text = palette_name
	$Dialog2.text = "Added to the pause menu"
	if enter_from == PALETTE_ENTER_DIRECTION.TOP:
		$AnimationTree['parameters/playback'].travel("enter")
	else:
		$AnimationTree['parameters/playback'].travel("enter_bottom")
func show_storybook_get(num_pages : int, enter_from : int):
	$Dialog.text = "New Storybook Page Found"
	$PaletteName.text = str(num_pages) + "/1"
	$Dialog2.text = "Storybook coming in the full version!"
	if enter_from == PALETTE_ENTER_DIRECTION.TOP:
		$AnimationTree['parameters/playback'].travel("enter")
	else:
		$AnimationTree['parameters/playback'].travel("enter_bottom")
