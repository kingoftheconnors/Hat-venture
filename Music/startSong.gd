# Song-starting functionality for using signals to affect music
extends AudioStreamPlayer

func start_music():
	print("Got start")
	play()
func start_sound():
	play()

func stop_music():
	print("Got stop")
	stop()
func stop_sound():
	stop()
