# Script for using and saving changes to the options menu
extends NinePatchRect

func _unhandled_input(event):
	# Open and close menu
	if event.is_action_pressed("ui_menu") or event.is_action_pressed("ui_B"):
		if openable and !visible and event.is_action_pressed("ui_menu") and !get_tree().paused:
			# Make this menu only active object while menu is open
			pause_mode = PAUSE_MODE_PROCESS
			get_tree().paused = true
			# Open menu
			show()
			reset_focus()
		elif visible:
			# Save settings when menu closes
			if dirty:
				save()
				dirty = false
			# Restore main game
			get_tree().paused = false
			pause_mode = PAUSE_MODE_INHERIT
			# Close menu
			hide()
		get_tree().set_input_as_handled()

func reset_focus(type : String = "default"):
	match type:
		"controls":
			$Controls.grab_focus()
		_:
			$MusicSlider.grab_focus()

## Save all game settings
func save():
	print($PaletteController.get_cur_palette())
	var settings = {
		"music_vol": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")),
		"sound_vol": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SoundEffects")),
		"palettes": $PaletteController.get_usable_palettes(),
		"cur_palette": $PaletteController.get_cur_palette(),
		"hud_size": $HudSizeController.get_cur_size()
	}
	save_system.save_settings(settings)

## Signal function for updating the game's volume
func _on_MasterVolSlider_value_changed(value):
	set_dirty()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), value == -50)

func _on_SoundSlider_value_changed(value):
	set_dirty()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), value == -50)

func set_dirty():
	dirty = true

var save_system : SaveSystem
var dirty = false
var openable = false

func set_openable(flag):
	openable = flag

func _ready():
	save_system = SaveSystem.new()
	var settings = save_system.load_settings()
	if settings.has("music_vol"):
		$MusicSlider.value = settings["music_vol"]
	if settings.has("sound_vol"):
		$SoundSlider.value = settings["sound_vol"]
	if settings.has("palettes") and settings["palettes"] is Array:
		var palettes = settings["palettes"]
		$PaletteController.set_usable_palettes(palettes)
	if settings.has("cur_palette"):
		$PaletteController.set_cur_palette(settings["cur_palette"])
	if settings.has("hud_size"):
		$HudSizeController.set_cur_size(settings["hud_size"])

