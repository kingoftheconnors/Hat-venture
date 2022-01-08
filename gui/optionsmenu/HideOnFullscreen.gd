extends HBoxContainer

func _ready():
	visible = !OS.window_fullscreen
	get_tree().connect("screen_resized", self, "hide_on_fullscreen")

func _exit_tree():
	get_tree().disconnect("screen_resized", self, "hide_on_fullscreen")

func hide_on_fullscreen():
	visible = !OS.window_fullscreen
