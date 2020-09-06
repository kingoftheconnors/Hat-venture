extends Node

# ALL ENEMIES SHOULD HAVE A HURTBOX OF AT LEAST RADIUS 3 or 4
signal hurt
onready var animator = get_node("AnimationTree")

export(int) var damage = 1

func get_damage():
	if damage == 0:
		print("WARNING: Getting 0 damage from " + self.name)
	return damage

func damage():
	emit_signal("hurt")
	animator["parameters/playback"].travel("die")
	# Always die, so always true
	return true

func die():
	get_parent().queue_free()
