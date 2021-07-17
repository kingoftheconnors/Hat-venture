extends HSlider

func _on_BrightnessSlider_value_changed(value):
	Gui.set_brightness(value)
