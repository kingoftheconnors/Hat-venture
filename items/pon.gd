class_name pon

func collect_as_item(_body, _this):
	# Update GUI
	PlayerGameManager.add_pons(1)
	PlayerGameManager.add_score(25)
	return true

func spawnFromBox(_collidingBody):
	# Get pon
	collect_as_item(null, null)
	# Spawn Pon Animation
	var pon = load("res://items/Resources/Pon.tscn")
	var instancedPon = pon.instance()
	instancedPon.set_position(Vector2(0, -16))
	instancedPon.get_node("AnimationPlayer").play("collect")
	return instancedPon

