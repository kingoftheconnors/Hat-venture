# Template item script. Manages all basic item tasks, and defers
# the item's effect to an exported script.
# Manages:
#    Item collection
#    Movement
extends Node2D

## Item's effect script. Must have a power() function that is
## called when the item is collected
export(Resource) var itemCommand
onready var wait_collect = 5
onready var animation_player = $AnimationPlayer
var collected = false

signal collected

func _physics_process(_delta):
	if wait_collect > 0:
		wait_collect -= 1

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and !collected:
		emit_signal("collected")
		collect(body)

func collect(body):
	if wait_collect <= 0 and !collected:
		collected = true
		var destroy = itemCommand.new().power(body, self)
		if destroy and animation_player != null and animation_player.has_animation("delayed_free"):
			animation_player.play("delayed_free")
		else:
			queue_free()
		emit_signal("collected")
		print("Collected")

func _on_Area2D_area_entered(area):
	if area.is_in_group("player") and !collected:
		var parent = area.get_parent()
		while parent.get_name() != "Player":
			parent = parent.get_parent()
		collect(parent)

func set_velo(_velo):
	$Body.velo = _velo
func set_velo_x(_velo):
	$Body.velo.x = _velo
func set_velo_y(_velo):
	$Body.velo.y = _velo
