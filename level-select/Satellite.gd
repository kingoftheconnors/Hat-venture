extends StaticBody2D

var corrected = false

func _ready():
	corrected = (SaveSystem.access_data().get_tag("satellite_aligned") != null)
	if corrected:
		$Satellite.frame = 1

func damage(_isStomp):
	return hit()

## Handles block being attacked by player
func hit():
	if !corrected:
		$Satellite.frame = 1
		$CPUParticles2D.emitting = false
		SaveSystem.access_data().set_tag("satellite_aligned", true)
		SoundSystem.call_deferred("start_sound", sound_system.SFX.YOU_DID_GOOD)
		corrected = true
		emit_signal("corrected")
	# Return false for un-smashed blocks
	return false

signal corrected
