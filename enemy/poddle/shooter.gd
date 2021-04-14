extends Node2D

# Shoop shoop
func shoot(path_to_root):
	if is_active:
		var root = get_node(path_to_root)
		var sprite = root.get_sprite()
		var bullet = preload("res://enemy/poddle/Poddleball.tscn")
		var poddleball = bullet.instance()
		poddleball.set_position(root.position + position + Vector2(sprite.scale.x*8, -2))
		poddleball.init(sprite.scale.x)
		root.get_parent().add_child(poddleball)

func _on_VisibilityNotifier2D_screen_entered():
	is_active = true

func _on_VisibilityNotifier2D_screen_exited():
	is_active = false

var is_active = false
