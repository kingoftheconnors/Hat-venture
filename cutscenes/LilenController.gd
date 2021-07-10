extends Node2D

export(Vector2) var goal = Vector2.ZERO
export(int) var num_lilens = 10

var num_to_generate = 0
var generated_lilens : Array = []
var goal_var : int = 0

func generate(goal_variance : int):
	goal_var = goal_variance
	num_to_generate = num_lilens
	$Timer.start()

func _on_Timer_timeout():
	num_to_generate -= 1
	var generated_lilen = preload("res://cutscenes/CutsceneLilen.tscn").instance()
	get_parent().add_child(generated_lilen)
	generated_lilen.init(self.position, self.position, goal, goal_var)
	generated_lilens.push_front(generated_lilen)
	if num_to_generate <= 0:
		$Timer.stop()

func recall():
	for lilen in generated_lilens:
		lilen.walk_to(self.position)

func hide_after_reaching_pos():
	for lilen in generated_lilens:
		lilen.flag_hide()

func shuffle():
	for lilen in generated_lilens:
		lilen.shuffle(40)

func get_timepieces():
	for lilen in generated_lilens:
		lilen.get_timepieces()
