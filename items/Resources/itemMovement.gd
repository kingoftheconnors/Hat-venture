extends KinematicBody2D

export(int) var gravityMultiplier = 0

var velo = Vector2()

func _physics_process(delta):
	velo.y += Constants.gravity * gravityMultiplier
	# terminal velocity
	if velo.y > Constants.terminalVelocity:
		velo.y = Constants.terminalVelocity
	move_and_slide(velo)
