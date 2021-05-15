extends Node
class_name sound_system

enum SFX {
	NONE,
	COLLECT,
	JUMP,
	DIVE,
	THROW,
	STOMP,
	LIFE_GET,
	POWERUP_GET,
	HURT,
	SPRINT,
	BLOCK_BREAK
}

enum MUSIC {
	NONE,
	VICTORY,
	GRASSLAND,
	GAMEOVER,
	GAMEOVER_SCREEN
}

onready var music_player : AudioStreamPlayer = $Music
func start_music(music : int):
	music_player.stop()
	match music:
		MUSIC.GAMEOVER:
			music_player.stream = preload("res://Music/Character_Death_Jingle.wav")
		MUSIC.GAMEOVER_SCREEN:
			music_player.stream = preload("res://Music/Game_Over2.ogg")
		MUSIC.GRASSLAND:
			music_player.stream = preload("res://Music/lvl1.ogg")
		MUSIC.VICTORY:
			music_player.stream = preload("res://Music/Win.ogg")
	music_player.play()
func stop_music():
	music_player.stop()

onready var sfx_player : AudioStreamPlayer = $Sfx
var cur_sound = SFX.NONE
func start_sound(sfx : int):
	if sfx_player:
		match sfx:
			SFX.COLLECT:
				collect_level += 1
				#if collect_level > 8:
				#	collect_level = 1
				collect_timer = COLLECT_RESET_TIME
				if collect_level == 1:
					sfx_player.stream = preload("res://Music/sfx/Coin_Pickup_1.wav")
				if collect_level == 2:
					sfx_player.stream = preload("res://Music/sfx/Coin_Pickup_2.wav")
				if collect_level == 3:
					sfx_player.stream = preload("res://Music/sfx/Coin_Pickup_3.wav")
				if collect_level == 4:
					sfx_player.stream = preload("res://Music/sfx/Coin_Pickup_4.wav")
				if collect_level == 5:
					sfx_player.stream = preload("res://Music/sfx/Coin_Pickup_5.wav")
				if collect_level == 6:
					sfx_player.stream = preload("res://Music/sfx/Coin_Pickup_6.wav")
				if collect_level == 7:
					sfx_player.stream = preload("res://Music/sfx/Coin_Pickup_7.wav")
				if collect_level >= 8:
					sfx_player.stream = preload("res://Music/sfx/Coin_Pickup_8.wav")
			SFX.JUMP:
				sfx_player.stream = preload("res://Music/sfx/jump.wav")
			SFX.LIFE_GET:
				sfx_player.stream = preload("res://Music/sfx/Life_Get.wav")
			SFX.DIVE:
				sfx_player.stream = preload("res://Music/sfx/dive.wav")
			SFX.THROW:
				return
				#sfx_player.stream = preload("res://Music/sfx/impact1.wav")
			SFX.STOMP:
				sfx_player.stream = preload("res://Music/sfx/Creature_Squash_4.wav")
				#sfx_player.stream = preload("res://Music/sfx/Creature_Squash.wav")
			SFX.POWERUP_GET:
				sfx_player.stream = preload("res://Music/sfx/Powerup_get.wav")
			SFX.HURT:
				sfx_player.stream = preload("res://Music/sfx/Character_hit.wav")
			SFX.SPRINT:
				if sprint_active:
					sfx_player.stream = preload("res://Music/sfx/Sprint.wav")
				else:
					sfx_player.stream = preload("res://Music/sfx/Sprint_start.wav")
			SFX.BLOCK_BREAK:
				var sounds = [
					preload("res://Music/sfx/Block_break_1.wav"),
					preload("res://Music/sfx/Block_break_2.wav"),
				]
				# Randomly use one of the block break sounds
				sfx_player.stream = sounds[randi() % len(sounds)]
		if cur_sound != sfx:
			sfx_player.stop()
		sfx_player.play()
		cur_sound = sfx
func start_sound_if_silent(sfx : int):
	if !sfx_player.is_playing():
		start_sound(sfx)
func stop_if_playing_sound(sfx : int):
	if cur_sound == sfx:
		cur_sound = SFX.NONE
		sfx_player.stop()
func stop_sound():
	cur_sound = SFX.NONE
	sfx_player.stop()

func _physics_process(_delta):
	if collect_timer > 0:
		collect_timer -= 1
		if collect_timer == 0:
			collect_level = 0
			print("Restart")
	if sprint_timer > 0 and cur_sound != SFX.SPRINT:
		sprint_timer -= 1
		if sprint_timer == 0:
			sprint_active = false
	elif cur_sound == SFX.SPRINT:
		sprint_timer = SPRINT_RESET_TIME
		sprint_active = true

var sprint_active = false
var sprint_timer = 0
const SPRINT_RESET_TIME = 60

var collect_level = 0
var collect_timer = 0
const COLLECT_RESET_TIME = 50
