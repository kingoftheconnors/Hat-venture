class_name hpon

func collect_as_item(body, _this):
	body.heal(1)
	return true

# Pons are not equipped as abilities, so so this isn't called
func activate(_body, _animator):
	pass
func activate_on_init(_body, _animator):
	pass

# Pons are not equipped as abilities, so this isn't called
func deactivate(_body, _animator):
	pass

func spawnFromBox(_collidingBody):
	# Get pon
	collect_as_item(null, null)
	# Spawn Pon Animation
	var pon = load("res://items/Resources/Pon.tscn")
	var instancedPon = pon.instance()
	instancedPon.set_position(Vector2(0, -16))
	instancedPon.get_node("AnimationPlayer").play("collect")
	return instancedPon

