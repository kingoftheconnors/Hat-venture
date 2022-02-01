extends VisibilityNotifier2D

export(String) var next_section = "res://title-screen/level-piece1.tscn"

func _on_VisibilityNotifier2D_screen_entered():
	call_deferred("spawn_piece")

func spawn_piece():
	var level = load(next_section).instance()
	level.position = position
	get_parent().add_child(level)
