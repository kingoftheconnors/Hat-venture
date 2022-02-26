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
	BLOCK_BREAK,
	BLOCK_BREAK_2,
	SKID,
	SKID2,
	DOOR,
	KNOCK,
	EXPLOSION,
	COLLECT_BASIC,
	STOMP2,
	STOMP3,
	ENEMY_BASH,
	BASH_OFF_WALL,
	SMACK_WALL,
	BOSS_LIFE_GET,
	ROBOHEN_SCREAM,
}

enum MUSIC {
	NONE,
	VICTORY,
	GRASSLAND,
	GAMEOVER,
	GAMEOVER_SCREEN,
	TIMMY,
	SHIP,
	TITLE,
	BOSS_1,
	TIMMY_STRIKES,
	TIME_PIECE_BUBBLE,
	NEW_VENTURE
}

onready var music_player : AudioStreamPlayer = $Music
var cur_music = MUSIC.NONE
func start_music(music : int, start_time : float = 0.0, fadein : bool = false):
	$AnimationPlayer.stop()
	if music_player:
		if fadein:
			fadein_music_fast()
		else:
			music_player.volume_db = 0
		if cur_music != music:
			music_player.stop()
			match music:
				MUSIC.GAMEOVER:
					music_player.stream = preload("res://Music/Character_Death_Jingle.wav")
				MUSIC.GAMEOVER_SCREEN:
					music_player.stream = preload("res://Music/Game_Over2.ogg")
				MUSIC.GRASSLAND:
					music_player.stream = preload("res://Music/Grass_World.ogg")
				MUSIC.VICTORY:
					music_player.stream = preload("res://Music/Time_Piece_Get.ogg")
				MUSIC.TIMMY:
					music_player.stream = preload("res://Music/Timmys_Theme.ogg")
				MUSIC.TIMMY_STRIKES:
					music_player.stream = preload("res://Music/Timmy_Strikes.ogg")
				MUSIC.SHIP:
					music_player.stream = preload("res://Music/Ship.ogg")
				MUSIC.TITLE:
					music_player.stream = preload("res://Music/Title_Theme.ogg")
				MUSIC.BOSS_1:
					music_player.stream = preload("res://Music/Boss_Theme.ogg")
				MUSIC.TIME_PIECE_BUBBLE:
					music_player.stream = preload("res://Music/Time_Piece_Bubble.ogg")
			    music_player.play(start_time)
				MUSIC.NEW_VENTURE:
					music_player.stream = preload("res://Music/A_New_Adventure.ogg")
			    music_player.play(0)
				MUSIC.TIME_PIECE_BUBBLE:
					music_player.stream = preload("res://Music/Time_Piece_Bubble.ogg")
			    music_player.play(start_time)
		cur_music = music
func skip_song_to(time : float):
	music_player.play(time)
func get_current_song_time():
	if in_transition_song:
		return in_transition_song
	return music_player.get_playback_position()
func get_current_song():
	if in_transition_time:
		return in_transition_time
	return cur_music
func stop_music():
	music_player.stop()
func fadeout_music():
	$AnimationPlayer.play("FadeOut")
func fadeout_music_fast():
	$AnimationPlayer.play("FadeOutFast")
func fadein_music():
	$AnimationPlayer.play("FadeIn")
func fadein_music_fast():
	$AnimationPlayer.play("FadeInFast")

var in_transition_time = null; var in_transition_song = null
func song_transition(song_to_play, start_time : float = 0.0):
	if music_player.volume_db < -50:
		# Skip to fadein
		song_fadeout_finished("", song_to_play, start_time, true)
	else:
		in_transition_time = start_time; in_transition_song = song_to_play
		var animation_player = $AnimationPlayer
		if animation_player.is_connected("animation_finished", self, "song_fadeout_finished"):
			animation_player.disconnect("animation_finished", self, "song_fadeout_finished")
		animation_player.connect("animation_finished", self, "song_fadeout_finished", [song_to_play, start_time, true])
		$AnimationPlayer.play("FadeOutFast")
func song_fadeout_finished(_anim_name, music : int, start_time : float = 0.0, fadein : bool = false):
	in_transition_time = null; in_transition_song = null
	start_music(music, start_time, fadein)
	var animation_player = $AnimationPlayer
	if animation_player.is_connected("animation_finished", self, "song_fadeout_finished"):
		animation_player.disconnect("animation_finished", self, "song_fadeout_finished")

onready var sfx_player : AudioStreamPlayer = $Sfx
var cur_sound = SFX.NONE
func start_sound(sfx : int, sound_var = 0):
	if sfx_player:
		sfx_player.volume_db = 0
		# Remove all bus effects
		for i in AudioServer.get_bus_effect_count(2):
			AudioServer.remove_bus_effect(2, 0)
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
			SFX.COLLECT_BASIC:
				sfx_player.stream = preload("res://Music/sfx/Coin_Pickup_1.wav")
			SFX.JUMP:
				sfx_player.stream = preload("res://Music/sfx/jump.wav")
			SFX.LIFE_GET:
				sfx_player.stream = preload("res://Music/sfx/Life_Get.wav")
			SFX.BOSS_LIFE_GET:
				sfx_player.stream = preload("res://Music/sfx/BossHealthIncrease.wav")
			SFX.DIVE:
				sfx_player.stream = preload("res://Music/sfx/dive.wav")
			SFX.THROW:
				return
				#sfx_player.stream = preload("res://Music/sfx/impact1.wav")
			SFX.STOMP:
				sfx_player.stream = preload("res://Music/sfx/Creature_Squash_4.wav")
				#sfx_player.stream = preload("res://Music/sfx/Creature_Squash.wav")
			SFX.STOMP2:
				sfx_player.stream = preload("res://Music/sfx/Creature_Squash_3.wav")
			SFX.STOMP3:
				sfx_player.stream = preload("res://Music/sfx/Creature_Squash.wav")
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
			SFX.BLOCK_BREAK_2:
				sfx_player.stream = preload("res://Music/sfx/Block_break_2.wav")
			SFX.SKID:
				sfx_player.stream = preload("res://Music/sfx/Skid_2.wav")
				# Add pitch shift
				var effect = AudioEffectPitchShift.new()
				effect.pitch_scale = sound_var/2 + 0.6
				AudioServer.add_bus_effect(2, effect)
				sfx_player.volume_db = -10
			SFX.SKID2:
				sfx_player.stream = preload("res://Music/sfx/Skid.wav")
			SFX.DOOR:
				sfx_player.stream = preload("res://Music/sfx/Door_Enter.wav")
			SFX.KNOCK:
				sfx_player.stream = preload("res://Music/sfx/knock.wav")
			SFX.EXPLOSION:
				sfx_player.stream = preload("res://Music/sfx/explosion.wav")
			SFX.ENEMY_BASH:
				sfx_player.stream = preload("res://Music/sfx/explosion.wav")
				sfx_player.volume_db = -10
			SFX.BASH_OFF_WALL:
				sfx_player.stream = preload("res://Music/sfx/hitWall.wav")
			SFX.SMACK_WALL:
				sfx_player.stream = preload("res://Music/sfx/hitWallHurt.wav")
			SFX.ROBOHEN_SCREAM:
				sfx_player.stream = preload("res://Music/sfx/RobohenDeathScream.wav")
		if cur_sound != sfx:
			sfx_player.stop()
		if sfx != SFX.NONE:
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
