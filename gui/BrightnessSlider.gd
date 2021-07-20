extends HSlider

func _on_BrightnessSlider_value_changed(value):
	Gui.set_brightness(value)

func set_to_default():
	value = default_val
	Gui.set_brightness(value)

export(int) var default_val = 0
