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
	HURT
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
	print(music)
	music_player.stop()
	match music:
		MUSIC.GAMEOVER:
			music_player.stream = preload("res://Music/Character_Death_Jingle.wav")
		MUSIC.GAMEOVER_SCREEN:
			music_player.stream = preload("res://Music/Game_Over2.ogg")
		MUSIC.GRASSLAND:
			music_player.stream = preload("res://Music/lvl1.ogg")
	music_player.play()
func stop_music():
	music_player.stop()

onready var sfx_player : AudioStreamPlayer = $Sfx
func start_sound(sfx : int):
	if sfx_player:
		sfx_player.stop()
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
		sfx_player.play()
func stop_sound():
	sfx_player.stop()

func _physics_process(_delta):
	if collect_timer > 0:
		collect_timer -= 1
		if collect_timer == 0:
			collect_level = 0
			print("Restart")

var collect_level = 0
var collect_timer = 0
const COLLECT_RESET_TIME = 50
