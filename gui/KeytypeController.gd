extends Label

# Change color to show focus
func _on_focus_entered():
	arrow.visible = true
func _on_focus_exited():
	arrow.visible = false

onready var arrow : Label = $Arrow
