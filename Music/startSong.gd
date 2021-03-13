# Song-starting functionality for using signals to affect music
extends Node

export(sound_system.SFX) var sound
export(sound_system.MUSIC) var music

# Placeholder_arg allows this function to be called by signals
# with a varying number of arguments, since non of the inputs
# are used.
func start_music(_placeholder_arg = null):
	SoundSystem.start_music(music)
func start_sound(_placeholder_arg = null):
	SoundSystem.start_sound(sound)

func stop_music(_placeholder_arg = null):
	SoundSystem.stop_music()
func stop_sound(_placeholder_arg = null):
	SoundSystem.stop_sound()

