extends Node2D

# Called when the node enters the scene tree for the first time.
func init(enemy):
	respawn_body = enemy

func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
	if !respawn_body.is_on_screen():
		respawn_body.respawn(position)

func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true

func is_on_screen():
	return on_screen

var respawn_body : Node
var on_screen : bool
