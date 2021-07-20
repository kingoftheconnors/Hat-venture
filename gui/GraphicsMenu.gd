extends "res://gui/SubMenu.gd"

## Save all keybind settings
func save():
	# Get keys from option keys in menu
	var keybinds = {}
	var graphics_settings = {
		"resolution": $ResolutionSelector.get_cur_resolution_name(),
		"fullscreen": $Fullscreen2.is_fullscreen(),
		"brightness": $BrightnessSlider.value,
		"hudsize": $HudSize.get_cur_size(),
		"parallax": $ParallaxSlider.value,
		"photosensitivity": $Photosensitivity2.get_photosensitivity_mode()
	}
	save_system = SaveSystem.new()
	save_system.overwrite_settings(graphics_settings)

func set_to_defaults():
	# Get keys from option keys in menu
	for node in get_children():
		if node.has_method("set_to_default"):
			node.set_to_default()

func _ready():
	save_system = SaveSystem.new()
	var settings = save_system.load_settings()
	if settings.has("resolution"):
		$ResolutionSelector.set_cur_resolution(settings["resolution"])
	if settings.has("fullscreen"):
		$Fullscreen2.set_fullscreen(settings["fullscreen"])
	if settings.has("brightness"):
		$BrightnessSlider.value = settings["brightness"]
	if settings.has("hudsize"):
		$HudSize.set_cur_size(settings["hudsize"])
	if settings.has("parallax"):
		$ParallaxSlider.value = settings["parallax"]
	if settings.has("photosensitivity"):
		$Photosensitivity2.set_photosensitivity_mode(settings["photosensitivity"])

var save_system : SaveSystem
