extends Area2D

export(String) var palette_name = "Classic"
export(unlock_box.PALETTE_ENTER_DIRECTION) var enter_from = unlock_box.PALETTE_ENTER_DIRECTION.TOP

func _ready():
	# if palette is already collected, delete this one
	if SaveSystem.access_data().is_palette_unlocked(palette_name):
		queue_free()
	$Sprite/AnimationPlayer.play("float")

func _on_Collectable_body_entered(body):
	if body.is_in_group("player"):
		SoundSystem.start_sound(SoundSystem.SFX.LIFE_GET)
		Gui.unlock_palette(palette_name, enter_from)
		queue_free()
