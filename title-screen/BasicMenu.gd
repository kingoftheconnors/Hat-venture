class_name menu
extends Control

export(NodePath) var first_item

export(bool) var enable_on_start = true
export(bool) var fade_in = false
export(bool) var fade_out = false
export(int) var appear_delay = 0
export(bool) var skippable = false

func _unhandled_input(event):
	if (event.is_action_pressed("ui_select") or event.is_action_pressed("ui_accept")) and (visible and skippable):
		close(true)

# You can use 'grab_focus()' to focus on the first element of the menu
func _ready() -> void:
	if enable_on_start:
		open()

var skipped = false
func open(skip_opening = false):
	skipped = false
	Gui.call_deferred("menu_opened")
	# Delay
	if skip_opening == false:
		yield(get_tree().create_timer(appear_delay), "timeout")
		# Check if skip occured during timer
		if skipped:
			return
	# Appear
	visible = true
	if fade_in:
		if skip_opening == false:
			if Constants.PHOTOSENSITIVE_MODE:
				$AnimationPlayer.play("fade_in_slow")
				yield(get_tree().create_timer(1), "timeout")
			else:
				$AnimationPlayer.play("fade_in")
				yield(get_tree().create_timer(1), "timeout")
			# Check if skip occured during timer
			if skipped:
				return
		else:
			$AnimationPlayer.play("fade_in_instant")
	# Grab focus
	var first = get_node_or_null(first_item)
	if first:
		first.grab_focus()
	# Connect sfx
	if $Mrgn.has_method("enable"):
		$Mrgn.call_deferred("enable")
	# Signal
	emit_signal("open")

func close(skip_end = false) -> void:
	if fade_out and skip_end == false:
		if Constants.PHOTOSENSITIVE_MODE:
			$AnimationPlayer.play("fade_out_slow")
			yield(get_tree().create_timer(1.6), "timeout")
		else:
			$AnimationPlayer.play("fade_out")
			yield(get_tree().create_timer(1.6), "timeout")
		# Check if skip occured during timer
		if skipped:
			return
	visible = false
	# Turn off sfx
	if $Mrgn.has_method("disable"):
		$Mrgn.call_deferred("disable")
	# Signal
	Gui.call_deferred("menu_closed")
	emit_signal("close", skip_end)
	if skip_end:
		emit_signal("close_skipping")
		skipped = true

signal close
signal open
signal close_skipping
