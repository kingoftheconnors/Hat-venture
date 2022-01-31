class_name menu
extends Control

export(NodePath) var first_item

export(bool) var enable_on_start = true
export(bool) var fade_in = false
export(bool) var fade_out = false
export(int) var appear_delay = 0

# You can use 'grab_focus()' to focus on the first element of the menu
func _ready() -> void:
	if enable_on_start:
		open()

func open():
	Gui.call_deferred("menu_opened")
	# Delay
	yield(get_tree().create_timer(appear_delay), "timeout")
	# Appear
	visible = true
	if fade_in:
		$AnimationPlayer.play("fade_in")
		yield(get_tree().create_timer(1), "timeout")
	# Grab focus
	var first = get_node_or_null(first_item)
	if first:
		first.grab_focus()
	# Connect sfx
	if $Mrgn.has_method("enable"):
		$Mrgn.call_deferred("enable")
	# Signal
	emit_signal("open")

func close() -> void:
	if fade_out:
		$AnimationPlayer.play("fade_out")
		yield(get_tree().create_timer(1), "timeout")
	visible = false
	# Turn off sfx
	if $Mrgn.has_method("disable"):
		$Mrgn.call_deferred("disable")
	# Signal
	Gui.call_deferred("menu_closed")
	emit_signal("close")

signal close
signal open
