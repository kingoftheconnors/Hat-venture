extends Sprite

#onready var jump_enem_sfx = get_node("SoundJumpEnmy")
#onready var hurt_sfx = get_node("SoundHurt")

onready var controller = get_parent().get_parent()
onready var hurtbox = get_node("../hurtbox")
onready var animator = get_node("../../AnimationTree")

var invincibility_frames = 0
var INVINCIBILITY_TIME = 50

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

func _process(_delta):
	if invincibility_frames > 0:
		invincibility_frames -= 1
		# Make every 10 frames be invisible to make flashing animation
		visible = (invincibility_frames % 10 < 5)
		if invincibility_frames == 0:
			turn_invincibilty(false)

func _on_hitbox_area_entered(area):
	if controller.get_stun() <= 0 and area.get_parent() != get_parent():
		if area.is_in_group("hurtbox"):
			# Play sound effect
			#jump_enem_sfx.play()
			area.get_parent().damage(true)
			# Jump up by damage amount
			controller.bounce()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("hitbox") and invincibility_frames <= 0 and area.get_parent() != get_parent():
		var damage = area.get_parent().get_damage()
		# TODO: Play sound effect
		damage(false, damage)
		animator['parameters/playback'].travel('hurt')
		# Bounce back
	elif area.is_in_group("ladder"):
		controller.on_ladders += 1

# Bash at body. If the object is destroyed, return true
func bash(body):
	if not body.is_in_group("player"):
		if body.has_method("damage"):
			# TODO: Play sound effect
			var destroyed = body.damage(false)
			if destroyed:
				controller.upgrade_smash()
			return destroyed
	return false

func cliff_damage():
	var dead = damage(false)
	if !dead:
		controller.reset_position()

func damage(isStomp, damage = 1):
	if health > 0:
		turn_invincibilty(true)
		health -= damage
		Gui.update_health(health, MAX_HEALTH)
		emit_signal("hurt")
		# Player doesn't die unless game ends, so always return false
		if health <= 0:
			die()
			return true
		else:
			return false
	return true

func heal(amo = 1):
	health = min(health + amo, MAX_HEALTH)
	Gui.update_health(health, MAX_HEALTH)

func turn_invincibilty(flag):
	if flag == true:
		invincibility_frames = INVINCIBILITY_TIME
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

func die():
	emit_signal("dead")
	LevelLoader.die()
