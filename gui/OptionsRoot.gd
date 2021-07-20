extends CanvasLayer

func add_palette(palette_name):
	$NinePatchRect/PaletteController.add_palette(palette_name)
	$NinePatchRect.save()

func set_openable(flag):
	$NinePatchRect.set_openable(flag)

func get_resolution() -> Vector2:
	return resolution_controller.get_cur_resolution()

onready var resolution_controller = $GraphicsMenu/ResolutionSelector

func photosensitivity_mode() -> bool:
	return photosensitivity_controller.get_photosensitivity_mode()
onready var photosensitivity_controller = $GraphicsMenu/Photosensitivity2
