extends Sprite

#onready var jump_enem_sfx = get_node("SoundJumpEnmy")
#onready var hurt_sfx = get_node("SoundHurt")

onready var controller = get_parent().get_parent()
onready var hurtbox = get_node("../hurtbox")

const KNOCKBACK_MULTIPLIER = 200
var invincibility_frames = 0
var INVINCIBILITY_TIME = 40

signal hurt
signal dead

func _process(delta):
	if invincibility_frames > 0:
		invincibility_frames -= 1
		# Make every 10 frames be invisible to make flashing animation
		visible = (invincibility_frames % 10 < 5)
		if invincibility_frames == 0:
			turn_invincibilty(false)

func _on_hitbox_area_entered(area):
	if controller.get_stun() <= 0:
		if area.is_in_group("hurtbox"):
			# Play sound effect
			#jump_enem_sfx.play()
			area.get_parent().get_node("EnemyCore").damage()
			# Jump up by damage amount
			controller.bounce()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("hitbox") and invincibility_frames <= 0:
		var damage = area.get_parent().get_node("EnemyCore").get_damage()
		#hurt_sfx.play()
		controller.stun(damage)
		take_damage(damage)
		# Bounce back
		var direc = (global_position - area.global_position).normalized() * KNOCKBACK_MULTIPLIER
		controller.push(direc)
	elif area.is_in_group("ladder"):
		controller.on_ladders += 1

func take_damage(damage):
	turn_invincibilty(true)
	Gui.damage()
	emit_signal("hurt")

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
	get_tree().quit()
