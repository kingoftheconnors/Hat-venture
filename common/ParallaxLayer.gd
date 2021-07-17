extends ParallaxLayer

## Mulitplier of parallax percent from the options menu to use to
## define what this ParallaxLayer's scale.x should be
export(float) var parallax_multiplier = 0.01

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	motion_scale.x = parallax_multiplier * Gui.get_parallax()
