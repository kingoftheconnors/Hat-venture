extends Area2D

export(String) var storybook_page = "World1Page"
export(unlock_box.PALETTE_ENTER_DIRECTION) var enter_from = unlock_box.PALETTE_ENTER_DIRECTION.TOP

func _ready():
	# if palette is already collected, delete this one
	if SaveSystem.access_data().get_tag(storybook_page) != null:
		queue_free()
	$Sprite/AnimationPlayer.play("float")

func _on_Collectable_body_entered(body):
	if body.is_in_group("player"):
		SoundSystem.start_sound(SoundSystem.SFX.LIFE_GET)
		Gui.unlock_storybook_page(get_num_pages(), enter_from)
		SaveSystem.access_data().set_tag(storybook_page, true)
		queue_free()
func get_num_pages() -> int:
	return 1
