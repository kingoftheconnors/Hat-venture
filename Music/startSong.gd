# Song-starting functionality for using signals to affect music
extends AudioStreamPlayer

# Placeholder_arg allows this function to be called by signals
# with a varying number of arguments, since non of the inputs
# are used.
func start_music(_placeholder_arg = null):
	play()
func start_sound(_placeholder_arg = null):
	play()

func stop_music(_placeholder_arg = null):
	stop()
func stop_sound(_placeholder_arg = null):
	stop()
