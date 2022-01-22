extends Node

var is_checked : bool = false
func mark_checked():
	is_checked = true

func send_signals():
	if is_checked:
		emit_signal("checked")
	else:
		emit_signal("notchecked")

signal checked
signal notchecked
