extends Sprite

## Value for screen shake. Set to 0 to turn off
var shake_amount : Vector2
#var shake_direc_right : bool = false
var shake_intensity : int = 0
var shake_duration : float = 0
func shake(amount : int, duration : float):
	shake_intensity = amount
	shake_duration = duration

func _process(delta):
	if shake_duration > 0.0:
		position -= shake_amount
		shake_duration -= delta
		if shake_duration > 0.0:
			var x_amo = randi() % (shake_intensity*2) - shake_intensity
			var y_amo = 0.0 #randi() % (shake_intensity*2) - shake_intensity
			shake_amount = Vector2(x_amo, y_amo)
			position += shake_amount
