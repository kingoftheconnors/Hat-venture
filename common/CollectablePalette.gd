extends Area2D

export(String) var palette_name = "Classic"

func _ready():
	# if palette is already collected, delete this one
	if SaveSystem.is_palette_unlocked(palette_name):
		queue_free()
	$Sprite/AnimationPlayer.play("float")

func _on_Collectable_body_entered(body):
	if body.is_in_group("player"):
		Gui.unlock_palette(palette_name)
		queue_free()
