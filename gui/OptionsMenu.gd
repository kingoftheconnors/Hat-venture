# Script for using and saving changes to the options menu
extends NinePatchRect

func _unhandled_input(event):
	# Open and close menu
	if event.is_action_pressed("ui_menu"):
		if !visible:
			# Make this menu only active object while menu is open
			pause_mode = PAUSE_MODE_PROCESS
			get_tree().paused = true
			# Open menu
			show()
		else:
			# Save settings when menu closes
			if dirty:
				save()
				dirty = false
			# Restore main game
			get_tree().paused = false
			pause_mode = PAUSE_MODE_INHERIT
			# Close menu
			hide()

## Save all game settings
func save():
	var settings = {
		"master_vol": master_volume
	}
	save_system.save_settings(settings)

## Signal function for updating the game's volume
func _on_MasterVolSlider_value_changed(value):
	master_volume = value
	dirty = true
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value-50)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value == 0)

var save_system : SaveSystem
var master_volume = 50
var dirty = false

func _ready():
	save_system = SaveSystem.new()
	var settings = save_system.load_settings()
	print(settings)
	if settings.has("master_vol"):
		master_volume = settings["master_vol"]
		$MasterVolSlider.value = master_volume
