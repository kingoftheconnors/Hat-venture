extends Node

func get_text(type):
	match type:
		"get_health_jar": return "Found a Spirit Jar!\n\nMax Health Increased!"
		"get_spectral_visor": return "Got Spectral View!\n Press D to switch to spectral view"
		"get_dash": return "Learned how to dash!\n Press x to dash forward\n You can also bounce off walls to gain an extra dash!"
		"beta_clear": return "Congratulations! You made it to the end! Thanks for playing."
