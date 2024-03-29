extends AnimationTree

func set_condition(condition_name, flag : bool):
	set("parameters/conditions/" + condition_name, flag)
	if condition_name in ["phase_1", "phase_2"]:
		set("parameters/hurt/HurtState/conditions/" + condition_name, flag)

func set_parameter(parameter_path, value):
	set("parameters/" + parameter_path, value)

#func _ready():
#	active = true
