extends Node

# Shoop shoop
func shoot(path_to_root):
	if is_active:
		var root = get_node(path_to_root)
		var sprite = root.get_sprite()
		var bullet = preload("res://enemy/vanill/Cherrybomb.tscn")
		var cherrybomb = bullet.instance()
		cherrybomb.set_position(root.position + Vector2(sprite.scale.x*8, -2))
		cherrybomb.init(sprite.scale.x, root)
		root.get_parent().add_child(cherrybomb)

func _on_VisibilityNotifier2D_screen_entered():
	is_active = true

func _on_VisibilityNotifier2D_screen_exited():
	is_active = false

var is_active = false
