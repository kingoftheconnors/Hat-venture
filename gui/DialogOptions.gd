extends HBoxContainer

func show_options(options : Dictionary):
	visible = true
	selected_option = -1
	for i in range(options.size()):
		option_labels[i].text = options.keys()[i]
		option_labels[i].option_value = options[options.keys()[i]]
	option_labels[0].grab_focus()

func hide_options():
	visible = false

func poll_user_selection():
	if get_focus_owner() == null:
		option_labels[0].grab_focus()
	return selected_option

func set_selected_option(value):
	selected_option = value

onready var option_labels = [$Option1, $Option2]
var selected_option : int = -1
