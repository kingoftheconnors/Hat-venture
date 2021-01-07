# Respawn point for an enemy. When player goes offscreen from an
# enemy's spawn point, they will respawn at this node
extends Node2D

## Init function. Must be called when first added
func init(enemy):
	respawn_body = enemy

## Signal function that tracks when player does not see respawn point.
## If the enemy this respawn is for is also off-screen then
## respawn enemy
func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
	if !respawn_body.is_on_screen():
		respawn_body.respawn(position)

## Signal function that tracks when player sees this respawn point.
func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true

## Getter for finding if the player can see this node
func is_on_screen():
	return on_screen

# Active node this respawnPoint is for
var respawn_body : Node
# Flags whether the respawnpoint is on screen
var on_screen : bool
