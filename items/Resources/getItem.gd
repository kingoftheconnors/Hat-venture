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

signal collected

func _physics_process(delta):
	if wait_collect > 0:
		wait_collect -= 1

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("collected")
		collect(body)

func collect(body):
	if wait_collect <= 0:
		var destroy = itemCommand.new().power(body, self)
		if destroy:
			queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		var parent = area.get_parent()
		while parent.get_name() != "Player":
			parent = parent.get_parent()
		emit_signal("collected")
		collect(parent)

func set_velo(_velo):
	get_node("Body").velo = _velo
func set_velo_x(_velo):
	get_node("Body").velo.x = _velo
func set_velo_y(_velo):
	get_node("Body").velo.y = _velo
