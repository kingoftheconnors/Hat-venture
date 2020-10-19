extends Sprite

#onready var jump_enem_sfx = get_node("SoundJumpEnmy")
#onready var hurt_sfx = get_node("SoundHurt")

onready var controller = get_parent().get_parent()
onready var hurtbox = get_node("../hurtbox")
onready var animator = get_node("../../AnimationTree")

var MAX_HEALTH = 4
var health = 4

signal hurt
signal dead

func _unhandled_input(event):
	if Constants.DEBUG_MODE:
		if event is InputEventKey and event.pressed and event.scancode == KEY_BRACELEFT:
			damage(false)
		if event is InputEventKey and event.pressed and event.scancode == KEY_BRACERIGHT:
			heal()

func _on_hitbox_area_entered(area):
	if controller.get_stun() <= 0 and area.get_parent() != get_parent():
		if area.is_in_group("hurtbox"):
			# Play sound effect
			#jump_enem_sfx.play()
			area.get_parent().damage(true)
			# Jump up by damage amount
			controller.bounce()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("hitbox") and area.get_parent() != get_parent():
		var damage = area.get_parent().get_damage()
		# TODO: Play sound effect
		damage(false, damage)
		# Bounce back
		controller.bounce_back()
	elif area.is_in_group("ladder"):
		controller.on_ladders += 1

# Bash at body. If the object is destroyed, return true
func attack(body):
	if not body.is_in_group("player"):
		if body.has_method("damage"):
			# TODO: Play sound effect
			var destroyed = body.damage(false)
			return destroyed
	return false

func cliff_damage():
	for i in range(health):
		damage(false)

func damage(isStomp, damage = 1):
	controller.can_dive = true
	controller.can_use_power = true
	health -= damage
	Gui.update_health(health, MAX_HEALTH)
	if health > 0:
		animator['parameters/PlayerMovement/playback'].travel('hurt')
		animator['parameters/PlayerEffect/playback'].travel('hurtFlash')
		emit_signal("hurt")
	else:
		player_die()
		return true
	# Player didn't die. Return false
	return false

func heal(amo = 1):
	health = min(health + amo, MAX_HEALTH)
	Gui.update_health(health, MAX_HEALTH)

func turn_invincibilty(flag):
	if flag == true:
		controller.set_collision_layer_bit(0, false)
		controller.set_collision_mask_bit(0, false)
		hurtbox.set_collision_layer_bit(0, false)
		hurtbox.set_collision_mask_bit(0, false)
	else:
		controller.set_collision_layer_bit(0, true)
		controller.set_collision_mask_bit(0, true)
		hurtbox.set_collision_layer_bit(0, true)
		hurtbox.set_collision_mask_bit(0, true)

func _on_hurtbox_area_exited(area):
	if area.is_in_group("ladder"):
		controller.on_ladders -= 1

var dying = false
func player_die():
	if !dying:
		controller.set_velo(Vector2(0, -300))
		controller.stun(40)
		animator['parameters/PlayerMovement/playback'].travel('die')
		dying = true

func die():
	emit_signal("dead")
	PlayerGameManager.die()

func pause_game():
	get_tree().paused = true
func resume_game():
	get_tree().paused = false
	print("Resume called")
