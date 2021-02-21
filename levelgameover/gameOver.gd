extends TextureRect

func accept_focus():
	reset_focus()

func reset_focus():
	$Continue.grab_focus()

func _ready():
	OptionsMenu.set_openable(false)
	reset_focus()
