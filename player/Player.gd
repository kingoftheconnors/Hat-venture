# Player core script.
# Manages:
#   Stomp Attacking
#	Health
#   Death
# REQUIREMENT: All enemies should have a hurtbox with a radius
# of at least radius 3
extends Sprite

onready var controller = get_parent().get_parent()
onready var hurtbox = $"../hurtbox"
onready var animator = $"../../AnimationTree"

var MAX_HEALTH = 4
var health = 4

signal hurt

func _process(_delta):
	if dying:
		controller.set_velo_x(0)
		if animating_death:
			animator['parameters/PlayerMovement/playback'].travel('die')
		else:
			animator['parameters/PlayerMovement/playback'].travel('die_simple')

func _unhandled_input(event):
	if Constants.DEBUG_MODE:
		if event is InputEventKey and event.pressed and event.scancode == KEY_BRACELEFT:
			damage(false)
		if event is InputEventKey and event.pressed and event.scancode == KEY_BRACERIGHT:
			heal()

func _on_hitbox_area_entered(area):
	if not area.is_in_group("player"):
		if area.is_in_group("hurtbox"):
			# Play sound effect
			#jump_enem_sfx.play()
			area.get_parent().damage(true)
			# Jump up by damage amount
			controller.bounce()

func _on_hurtbox_area_entered(area):
	if area.is_in_group("hitbox") and area.get_parent() != get_parent():
		var damage = area.get_damage()
		# TODO: Play sound effect
		damage(false, damage)
		# Bounce back
		controller.bounce_back()
	elif area.is_in_group("ladder"):
		controller.on_ladders += 1

## Attacks given body if possible. If the object is destroyed, return true
func attack(body):
	if body.has_method("damage"):
		# TODO: Play sound effect
		var destroyed = body.damage(false)
		return destroyed
	return false

## Take damage when falling off cliff. Kills player INSTANTLY
func cliff_damage():
	health = 0
	Gui.update_health(health, MAX_HEALTH)
	player_die(false)

func damage(_isStomp, damage = 1):
	controller.can_dive = true
	controller.can_use_power = true
	health -= damage
	Gui.update_health(health, MAX_HEALTH)
	if health > 0:
		animator['parameters/PlayerMovement/playback'].travel('hurt')
		if !Constants.PHOTOSENSITIVE_MODE:
			animator['parameters/PlayerEffect/playback'].travel('hurtFlash')
		emit_signal("hurt")
		SoundSystem.start_sound(SoundSystem.SFX.HURT)
	else:
		player_die()
		return true
	# Player didn't die. Return false
	return false

func heal(amo = 1):
	health = min(health + amo, MAX_HEALTH)
	Gui.update_health(health, MAX_HEALTH)

onready var uninvincible_timer = $"../../Uninvincible"
func turn_invincibilty(flag, auto_end = false):
	if flag == true:
		if auto_end:
			uninvincible_timer.start()
		#controller.set_collision_layer_bit(0, false)
		#controller.set_collision_mask_bit(0, false)
		hurtbox.set_collision_layer_bit(0, false)
		hurtbox.set_collision_mask_bit(0, false)
	else:
		uninvincible_timer.stop()
		#controller.set_collision_layer_bit(0, true)
		#controller.set_collision_mask_bit(0, true)
		hurtbox.set_collision_layer_bit(0, true)
		hurtbox.set_collision_mask_bit(0, true)

func _on_hurtbox_area_exited(area):
	if area.is_in_group("ladder"):
		controller.on_ladders -= 1

var dying = false
var animating_death = false
func player_die(animate = true):
	if !dying:
		controller.signal_death()
		controller.get_power_node().silent_release_power()
		animating_death = animate
		controller.stun(40)
		dying = true

func die():
	PlayerGameManager.die()

func pause_game():
	PlayerGameManager.pause_except([])
	yield(get_tree().create_timer(0.5), "timeout")
	PlayerGameManager.unpause()
	PlayerGameManager.pause_except([controller])
	yield(get_tree().create_timer(0.3), "timeout")
	PlayerGameManager.unpause()
