extends Node

export(sound_system.MUSIC) var level_music
func _ready():
	SoundSystem.start_music(level_music)

func skip_song_to(time : float):
	SoundSystem.skip_song_to(time)
