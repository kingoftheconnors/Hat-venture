extends Path2D

var cur_goal : Vector2
## Flag that determines whether to destroy this node when reaching end of path
export(bool) var hide_flag = false

func init(pos : Vector2, start : Vector2, end : Vector2, goal_variance : int):
	$Lilen.position = pos
	var new_curve = Curve2D.new()
	new_curve.add_point(start)
	new_curve.add_point(end + Vector2((randf()*2-1) * goal_variance, 0))
	curve = new_curve
	cur_goal = end

func walk_to(pos : Vector2):
	var new_curve = Curve2D.new()
	new_curve.add_point(cur_goal)
	new_curve.add_point(pos)
	curve = new_curve
	$Lilen.reset()
	cur_goal = pos

func shuffle(shuffle_width : int):
	$Lilen.position.x += (randf()*2-1) * shuffle_width

func flag_hide():
	hide_flag = true

func _on_Lilen_reach_goal():
	if hide_flag:
		queue_free()

func get_timepieces():
	$Lilen.get_timepieces()
