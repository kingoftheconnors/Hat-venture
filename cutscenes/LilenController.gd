extends Node2D

export(Vector2) var goal = Vector2.ZERO
export(int) var num_lilens = 10

var num_to_generate = 0
var generated_lilens : Array = []
var goal_var : int = 0
var has_timepieces : bool = false
var hide_flagged : bool = false

export(float, .1, .5) var jump_wait_time_min = .1
export(float, .2, .7) var jump_wait_time_max = .5

func generate(goal_variance : int, time_between = 0):
	goal_var = goal_variance
	num_to_generate = num_lilens
	if time_between > 0:
		$Timer.start(time_between)
	else:
		$Timer.start()

func _on_Timer_timeout():
	num_to_generate -= 1
	var generated_lilen = preload("res://cutscenes/CutsceneLilen.tscn").instance()
	get_parent().add_child(generated_lilen)
	generated_lilen.init(self.position, self.position, goal, goal_var, jump_wait_time_min, jump_wait_time_max)
	generated_lilens.push_front(generated_lilen)
	if has_timepieces:
		generated_lilen.get_timepieces()
	if hide_flagged:
		generated_lilen.flag_hide()
	if num_to_generate <= 0:
		$Timer.stop()

func recall():
	for lilen in generated_lilens:
		lilen.walk_to(self.position)
		lilen.stop_jumping()

func hide_after_reaching_pos():
	hide_flagged = true
	for lilen in generated_lilens:
		lilen.flag_hide()

func shuffle():
	for lilen in generated_lilens:
		lilen.shuffle(40)

func get_timepieces():
	has_timepieces = true
	for lilen in generated_lilens:
		lilen.get_timepieces()
