extends Area2D

export(bool) var active = true
var start_time : float = 0.0
var song_to_play = sound_system.MUSIC.TIME_PIECE_BUBBLE

func _ready():
	if !active:
		visible = false
		$CollisionShape2D.disabled = true
		$EntranceBox/CollisionShape2D2.disabled = true

func activate():
	active = true
	visible = true
	$CollisionShape2D.disabled = false
	$EntranceBox/CollisionShape2D2.disabled = false

## Captures the camera
func _on_CameraCapture_body_entered(body):
	if body.is_in_group("player") and active:
		#$TextureRect.visible = true
		$AnimationPlayer.play("grow")
		play_song_to_play()

func play_song_to_play():
		var old_song = SoundSystem.get_current_song()
		var old_time = SoundSystem.get_current_song_time()
		# Turn on time piece music
		SoundSystem.song_transition(song_to_play, start_time)
		start_time = old_time
		song_to_play = old_song

func _on_CameraCapture_body_exited(body):
	if body.is_in_group("player") and active:
		#$TextureRect.visible = false
		$AnimationPlayer.play("shrink")
		play_song_to_play()
