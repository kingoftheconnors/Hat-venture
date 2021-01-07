# Player movement script and node root. Handles all public-facing
# methods, as well as all movement calculations.
# REQUIREMENTS: Expects the PlayerCore script
# as a child in the path: "ScaleChildren/PlayerCore"
extends KinematicBody2D

signal off_cliff
signal dead

# BASIC MOVEMENT
const PLAYER_GRAVITY = 10
const TURNOFF_SPEED = 15
const BASE_SPEED = 10 #25
var base_speed = BASE_SPEED
const ACCELERATION = 5
const MAX_SPEED = 93
var BOUNCE_FORCE := 300
var FALL_MULTIPLIER : float = 1.1
var JUMP_STRENGTH := 275

# DIVE
var diving = false
var can_superdive = false
var can_dive = true
const SUPERDIVE_TIME = 7
var superdive_timer = 0
var mini_superdive_timer = 0
const DIVE_SPEED = 192
const DIVE_FALL_MULTIPLIER = 0.85
const DIVE_OUT_STRENGTH = 200
const DIVE_OUT_SPEED = 140
const SUPERDIVE_SPEED = 250
const MINI_SUPERDIVE_SPEED = 205
const DIVE_MERCY = 3

# POWERS
var power_stun = 0
var can_use_power = true

# RUN
const MAX_RUNNING_SPEED = 212
var running

# SPIN
var spinning
const SPIN_JUMP_SPEED = 265
const SPIN_HORIZONTAL_SPEED = 155
const SPIN_FORWARD_SPEED = 180
const SPIN_LENGTH = 1.5
const POST_SPIN_STUN = 20
const SPIN_FALL_MULTIPLIER = 0.65
const SPIN_TERMINAL_VELOCITY_MULTIPLIER = 0.25
const SPIN_JUMP_DECELERATION = 0.89
const SPIN_DECELERATION = 0.85
const SPIN_ACCELERATION = 15

# BASH
var power_combo = false
var bashing = false
const BASH_SPEED = 180
const POST_CRASH_SPEED = 200
const KNOCKBACK_MULTIPLIER = 140
const POST_BASH_STUN = 38
const BASH_CORRECTION_SIZE = 14
const POST_BASH_JUMP_TIME = 10
var post_bash_jump_timer = 0
const BASH_OUT_STRENGTH = 180

# CLIMBING
var CLIMBING_SPEED := 200
var WALL_CLIMBING_SPEED := 150
var wall_climbing := false

# Sound effects
#onready var jump_sfx = get_node("SoundJump")
onready var scale_manager = get_node("ScaleChildren")
onready var animator = get_node("AnimationTree")
onready var animatorPlayer = get_node("AnimationPlayer")
onready var camera = get_node("../Camera")
onready var core = get_node("ScaleChildren/PlayerCore")

onready var skidRayCast1 = get_node("SkidRay")
onready var skidRayCast2 = get_node("SkidRay2")

# Movement vars
var _stun = 0
var frozen = false
var suspended = false
var ignore_air_friction = false
var crouching = false
var gravity = true

var max_velo = MAX_SPEED
var velo = Vector2()

var jump_timer = 0
const JUMP_TIME = 10
var coyoteTimer = 0
var climbing = false
var air_time = 0
var skid_perfect = false

# Initial spawn for players dying. An educated guess for a legal, safe position
var cur_spawn = Vector2()

var release_jump_damp : float = 0.4

var direction = 1

var on_ladders = 0

## Respawn hero at level spawn
func reset_position():
	position = cur_spawn
	velo = Vector2()

## Sets level spawn
func set_spawn(pos):
	position = pos
	cur_spawn = pos

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move(delta)
	manage_flags()

## Calculates velocity and moves player
func move(delta):
	var horizontal = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var vertical = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	
	if _stun > 0:
		horizontal = 0
		vertical = 0
		_stun -= 1
	
	if bashing:
		horizontal = direction
	if spinning:
		# A horizontal opposite the current direction is treated as 0 (slow down)
		if horizontal > 0:
			max_velo = SPIN_FORWARD_SPEED
		else:
			max_velo = SPIN_HORIZONTAL_SPEED
		if horizontal * direction >= 0:
			horizontal = direction
		else:
			horizontal = 0
	if frozen or diving:
		horizontal = 0; vertical = 0
	
	# Setting direction
	if horizontal * direction < 0:
		if horizontal > 0:
			direction = 1
		else:
			direction = -1
	if scale_manager.scale.x != direction:
		scale_manager.scale = Vector2(direction, 1)
	
	# Crouching (can turn around but doesn't move')
	if crouching and is_on_floor():
		horizontal = 0
	
	# Friction (before moving so friction only applies when player is
	# standing still or going over conventional speeds)
	if horizontal == 0 and spinning:
		if abs(velo.x) > MAX_SPEED:
			if is_on_floor():
				velo.x *= SPIN_DECELERATION
			else:
				velo.x *= SPIN_JUMP_DECELERATION
	elif (horizontal == 0 and !ignore_air_friction and !is_on_floor()):
		velo.x *= 0.87
	elif (horizontal == 0 and !crouching and is_on_floor()):
		velo.x *= 0.87
	elif ((is_on_floor() or bashing) and abs(velo.x) > max_velo):
		velo.x *= 0.87
	elif diving: # Diving friction
		if is_on_floor():
			velo.x *= 0.93
	elif crouching:
		velo.x *= 0.96
	
	# Basic movement
	if bashing:
	#	velo = Vector2(direction * max_velo, 0)
	#elif spinning:
		velo.x = direction * max_velo
	elif spinning:
		velo.x = calc_direc(direction, velo.x, SPIN_ACCELERATION)
	else:
		velo.x = calc_direc(horizontal, velo.x, ACCELERATION)
	
	# Skid perfect
	if skid_perfect and is_on_floor():
		if !skidRayCast1.is_colliding() or !skidRayCast2.is_colliding():
			velo.x *= 0.86
	if spinning and horizontal == 0 and is_on_floor():
		if !skidRayCast1.is_colliding() or !skidRayCast2.is_colliding():
			velo.x *= 0.7
	
	# Animating
	if horizontal != 0:
		animator["parameters/PlayerMovement/conditions/walking"] = true
		animator["parameters/PlayerMovement/conditions/not_walking"] = false
		animator["parameters/PlayerMovement/walk/4/blend_position"] = abs(velo.x)/MAX_RUNNING_SPEED
		animator["parameters/PlayerMovement/walk/4/1/Speed/scale"] = .5 + abs(velo.x)/MAX_RUNNING_SPEED
	else:
		animator["parameters/PlayerMovement/conditions/walking"] = false
		animator["parameters/PlayerMovement/conditions/not_walking"] = true
	
	if velo.x * horizontal < 0:
		animator["parameters/PlayerMovement/conditions/skidding"] = true
		animator["parameters/PlayerMovement/conditions/not_skidding"] = false
	else:
		animator["parameters/PlayerMovement/conditions/skidding"] = false
		animator["parameters/PlayerMovement/conditions/not_skidding"] = true
	
	if diving:
		if is_on_floor():
			animator["parameters/PlayerMovement/conditions/dive_resting"] = true
			animator["parameters/PlayerMovement/conditions/not_dive_resting"] = false
		else:
			animator["parameters/PlayerMovement/conditions/dive_resting"] = false
			animator["parameters/PlayerMovement/conditions/not_dive_resting"] = true
	
	#Gravity
	if gravity and !climbing:
		if velo.y < 0:
			velo.y += PLAYER_GRAVITY
		else:
			if diving:
				velo.y += PLAYER_GRAVITY * DIVE_FALL_MULTIPLIER
			elif spinning:
				velo.y += PLAYER_GRAVITY * SPIN_FALL_MULTIPLIER
			else:
				velo.y += PLAYER_GRAVITY * FALL_MULTIPLIER
			# terminal velocity
			if velo.y > Constants.terminalVelocity:
				velo.y = Constants.terminalVelocity
			if spinning and velo.y > Constants.terminalVelocity*SPIN_TERMINAL_VELOCITY_MULTIPLIER:
				velo.y = Constants.terminalVelocity*SPIN_TERMINAL_VELOCITY_MULTIPLIER
	
	# Ladder climbing
	if vertical != 0 and on_ladders > 0:
		velo.y = vertical * CLIMBING_SPEED
		climbing = true
	elif climbing:
		if vertical == 0:
			velo.y = 0
		if on_ladders == 0:
			climbing = false
	
	# Apply Movement
	if !suspended:
		velo = move_player(velo)
	
	if position.y > camera.limit_bottom + 20:
		emit_signal("off_cliff")

## Calculates and returns the velocity of a single axis based on direction,
## acceleration, and current speed.
func calc_direc(ui_direc, cur_speed, accel = ACCELERATION, speed = base_speed) -> float:
	if ui_direc > 0 and cur_speed >= ui_direc*base_speed*.9: # Accelerate right
		return max(cur_speed, min(cur_speed + ui_direc*accel, max_velo))
	elif ui_direc > 0 and cur_speed > -ui_direc*TURNOFF_SPEED: # On low speed, set to base speed instantly
		return max(cur_speed, ui_direc*speed)
	elif ui_direc < 0 and cur_speed <= ui_direc*base_speed*.9: # Accelerate left
		return min(cur_speed, max(cur_speed + ui_direc*accel, -max_velo))
	elif ui_direc < 0 and cur_speed < -ui_direc*base_speed: # On low speed, set to base speed instantly
		return min(cur_speed, ui_direc*speed)
	elif ui_direc != 0:  # Sliding for when velo is launched out of regular range (and attempting to turn back)
		return cur_speed + ui_direc*accel
	elif ui_direc == 0 and abs(cur_speed) <= TURNOFF_SPEED:  # Hard stop on release
		return 0.0
	else:
		return cur_speed

onready var feetCollider = get_node("FeetCollider")
func move_player(v):
	#var snap = Vector2.DOWN * 16 if is_on_floor() and !just_jumped else Vector2.ZERO
	var prev_velo = v
	var new_velo = move_and_slide(v, Vector2.UP)#_with_snap(velo, snap, Vector2.UP, true)
	var recognize_collision = true
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision != null:
			if !collision.collider.is_in_group("player"):
				# Special cases when hitting level tiles
				if collision.collider.get_collision_layer_bit(1) == true:
					# Corner correction
					if collision.local_shape.get_name() == "HeadCollider":
						if collision.position.y > collision.local_shape.global_position.y - collision.local_shape.shape.radius + .15:
							# Push player vertically and set recognize_collision to false
							recognize_collision = false
							if collision.position.x < global_position.x:
								position.x += 1
							else:
								position.x -= 1
					# Hitting blocks
					if recognize_collision:
						if collision.local_shape != feetCollider:
							if collision and collision.collider.is_in_group("block"):
								collision.collider.collide(collision, self)
			# Spin turning around
			if spinning and recognize_collision:
				if abs(collision.normal.x) > abs(collision.normal.y):
					var destroyedBody = spin_bounce(collision.collider)
					if !destroyedBody:
						direction = -direction
			# Bash Hitting
			if bashing and recognize_collision:
				if abs(collision.normal.x) > abs(collision.normal.y):
					var destroyedBody = bash_bounce(collision.collider)
	if !recognize_collision:
		new_velo = prev_velo
	#if bashing:
	#	new_velo.y = 0
	return new_velo

onready var bash_collider = get_node("ScaleChildren/bashbox/BashCollider")
func bash_bounce(body):
	# Special cases when bashing
	if bashing:
		if !body.is_in_group("player"):
			var destroyedBody = core.attack(body)
			print("Destroyed: ", destroyedBody)
			# Smashing through an object (disabling its collision)
			if destroyedBody:
				# Move towards center
				upgrade_smash()
				body.set_collision_layer(0)
				body.set_collision_mask(0)
				#recognize_collision = false
			else:
				# Bash Corner Correction
				var recognize_collision = true
				var space_state = get_world_2d().direct_space_state
				var topPos = bash_collider.global_position-Vector2(0, bash_collider.shape.extents.y)
				var bottomPos = bash_collider.global_position+Vector2(0, bash_collider.shape.extents.y)
				# Test corner correction downwards
				var upperHit = space_state.intersect_ray(topPos, topPos+Vector2(5*direction, 0), [], 2)
				var lowerHit = space_state.intersect_ray(bottomPos, bottomPos+Vector2(5*direction, 0), [], 2)
				if upperHit and !lowerHit:
					for i in range(BASH_CORRECTION_SIZE):
						var result = space_state.intersect_ray(topPos+Vector2(0, i), topPos+Vector2(5*direction, i), [], 2)
						if !result:
							recognize_collision = false
							move_and_collide(Vector2(0, i+1))
							pause_gravity()
							break
				# Test corner correction upwards
				if lowerHit and !upperHit:
					for i in range(BASH_CORRECTION_SIZE):
						var result = space_state.intersect_ray(bottomPos+Vector2(0, -i), bottomPos+Vector2(5*direction, -i), [], 2)
						if !result:
							recognize_collision = false
							move_and_collide(Vector2(0, -(i+1)))
							pause_gravity()
							break
				if recognize_collision:
					# No corner correction, bounce off
					bounce_back()
					print("Bouncing")
					unbash()

func bounce_back():
	var direc = Vector2(-direction, -0.5) * KNOCKBACK_MULTIPLIER
	push(direc)

func spin_bounce(body):
	if !body.is_in_group("player"):
		var destroyedBody = core.attack(body)
		if destroyedBody:
			body.set_collision_layer(0)
			body.set_collision_mask(0)
		return destroyedBody
	return false

func push(direc):
	if ( velo.x * direc.x < 0 or abs(velo.x) < abs(direc.x) ):
		velo.x = direc.x
	if ( velo.y * direc.y < 0 or abs(velo.y) < abs(direc.y) ):
		velo.y = direc.y

## Processing function called once per frame that tracks all bit timers
## and state flags for the player
func manage_flags():
	power_stun_frame()
	
	if is_on_floor() or climbing:
		refresh_flags()
	else:
		# First frame off ground
		if !air_time:
			air_time = true
			PlayerGameManager.set_multiplicity_fast_decrease(false)
		if coyoteTimer > 0:
			coyoteTimer -= 1
	
	# First frame on ground
	if is_on_floor() and air_time:
		air_time = false
		PlayerGameManager.set_multiplicity_fast_decrease(true)
		animator["parameters/PlayerMovement/conditions/jumping"] = false
		animator["parameters/PlayerMovement/conditions/not_jumping"] = true
	
	if is_on_floor() and ignore_air_friction:
		if !bashing and !diving and !spinning and abs(velo.x) < max_velo*.8:
			ignore_air_friction = false
	
	if diving and is_on_floor() and can_superdive:
		superdive_timer = SUPERDIVE_TIME
		can_superdive = false
	
	if diving and !is_on_floor() and !can_superdive:
		can_superdive = true
	
	if superdive_timer > 0:
		superdive_timer -= 1
	if mini_superdive_timer > 0:
		mini_superdive_timer -= 1
	if post_bash_jump_timer > 0:
		post_bash_jump_timer -= 1
	
	if jump_timer > 0:
		jump_timer -= 1
		if _stun <= 0 \
			and (is_on_floor() \
				or coyoteTimer > 0 \
				or climbing \
				or diving \
				or (post_bash_jump_timer > 0)):
			jump()

func refresh_flags():
	if coyoteTimer < 5:
		coyoteTimer = 5
	if !can_dive:
		can_dive = true

var holding_jump = false

func _unhandled_input(event):
	if !frozen:
		# This will run once on the frame when the action is first pressed
		if event.is_action_pressed("ui_A"):
			holding_jump = true
			jump_timer = JUMP_TIME
		
		if event.is_action_released("ui_A"):
			if holding_jump and !spinning and !diving and velo.y < 0:
				velo.y *= release_jump_damp
				#animator["parameters/playback"].travel("freefall")
			holding_jump = false
			jump_timer = 0
		
		if event.is_action_pressed("ui_crouch"):
			crouch()
		if event.is_action_released("ui_crouch"):
			uncrouch()

func jump():
	if post_bash_jump_timer > 0 and !is_on_floor():
		push(Vector2(0, -BASH_OUT_STRENGTH))
	elif !diving: # Basic Jump
		push(Vector2(0, -JUMP_STRENGTH))
	else: # Out-of-dive Jump
		undive()
		push(Vector2(0, -DIVE_OUT_STRENGTH))
		if (superdive_timer > 0) or (!is_on_floor() and move_and_collide(Vector2(0, DIVE_MERCY), true, true, true)):
			push(Vector2(direction * SUPERDIVE_SPEED, -SUPERDIVE_SPEED))
			animator["parameters/PlayerMovement/playback"].travel("dive_boost")
		if (mini_superdive_timer > 0):
			push(Vector2(direction * SUPERDIVE_SPEED, -SUPERDIVE_SPEED))
			animator["parameters/PlayerMovement/playback"].travel("dive_boost")
	# Energy jump
	coyoteTimer = 0
	jump_timer = 0
	climbing = false
	#jump_sfx.play()
	animator["parameters/PlayerMovement/conditions/jumping"] = true
	animator["parameters/PlayerMovement/conditions/not_jumping"] = false

## Bounces player upwards (used when stepping on enemy or spring)
func bounce():
	var direc = Vector2(0, -BOUNCE_FORCE)
	if !holding_jump:
		direc *= release_jump_damp
	push(direc)
	if diving and can_superdive:
		superdive_timer = SUPERDIVE_TIME
	refresh_flags()

func get_stun():
	return _stun

func release_all_powers():
	if bashing:
		animator["parameters/PlayerMovement/playback"].start("end_bash")
		unbash()
	if spinning:
		animator["parameters/PlayerMovement/playback"].start("end_spin")
		unspin()
	if diving:
		animator["parameters/PlayerMovement/playback"].start("end_dive")
		undive()

func stun(amo, stun_mult = 3):
	_stun = amo * stun_mult
	release_all_powers()

func power_stun(amo):
	animator["parameters/PlayerEffect/playback"].travel("powerlessFlash")
	power_stun = amo
	
func power_stun_frame():
	if power_stun > 0:
		power_stun -= 1
		if power_stun <= 0:
			animator["parameters/PlayerEffect/playback"].travel("powerlessOff")
			can_use_power = true

func set_freeze(flag):
	if flag == true:
		release_all_powers()
	frozen = flag

func suspend_movement(flag):
	suspended = flag

# Universal method for other nodes to know if keys and actions from
# the player can be used. This is good for dialog, death scenes, etc
func is_active():
	return !frozen

func dive():
	if can_dive and !diving:
		can_dive = false
		diving = true
		ignore_air_friction = true
		max_velo = DIVE_SPEED
		velo = Vector2(DIVE_SPEED * direction, -DIVE_SPEED*3/4)
		animator["parameters/PlayerMovement/playback"].travel("dive")
		animator["parameters/PlayerMovement/conditions/jumping"] = false
		animator["parameters/PlayerMovement/conditions/not_jumping"] = true
func undive():
	diving = false
	max_velo = MAX_SPEED
	if velo.x > 0:
		velo.x = min(DIVE_OUT_SPEED, velo.x)
	else:
		velo.x = max(-DIVE_OUT_SPEED, velo.x)

func crouch():
	crouching = true
	animator["parameters/PlayerMovement/conditions/crouching"] = true
	animator["parameters/PlayerMovement/conditions/not_crouching"] = false
func uncrouch():
	crouching = false
	animator["parameters/PlayerMovement/conditions/crouching"] = false
	animator["parameters/PlayerMovement/conditions/not_crouching"] = true

func start_run():
	max_velo = MAX_RUNNING_SPEED
	#base_speed = BASE_RUN_SPEED
	running = true
func stop_run():
	max_velo = MAX_SPEED
	#base_speed = BASE_SPEED
	running = false

func start_skid_perfect():
	skid_perfect = true
func stop_skid_perfect():
	skid_perfect = false

func bash():
	if !bashing and can_use_power and _stun <= 0:
		can_use_power = false
		bashing = true
		ignore_air_friction = true
		uncrouch()
		max_velo = BASH_SPEED
		if !is_on_floor():
			velo.y = 0; pause_gravity()
		animator["parameters/PlayerMovement/playback"].travel("bash")

func upgrade_smash():
	print("Upgrading: ", bashing)
	if bashing:
		suspend_movement(true)
		animator["parameters/PlayerMovement/playback"].start("pre-bash")
		power_combo = true

func upgrade_smash_rush():
	suspend_movement(false)
	max_velo = POST_CRASH_SPEED
	push(Vector2(direction * max_velo, 0))
	velo.y = 0
	pause_gravity()

func unbash():
	print("Unbashing: ", bashing)
	resume_gravity()
	if bashing:
		if velo.x > max_velo:
			velo.x = max(MAX_SPEED, velo.x - (max_velo - MAX_SPEED))
		elif velo.x < -max_velo:
			velo.x = min(-MAX_SPEED, velo.x + (max_velo - MAX_SPEED))
		max_velo = MAX_SPEED
		bashing = false
		if power_combo == false:
			power_stun(POST_BASH_STUN)
		else:
			can_use_power = true
		power_combo = false
		post_bash_jump_timer = POST_BASH_JUMP_TIME
		core.turn_invincibilty(true)

func spin():
	if !spinning and can_use_power and _stun <= 0:
		can_use_power = false
		spinning = true
		ignore_air_friction = true
		uncrouch()
		max_velo = SPIN_HORIZONTAL_SPEED
		if !is_on_floor():
			push(Vector2(0, -SPIN_JUMP_SPEED))
		animator["parameters/PlayerMovement/playback"].travel("spin")
		yield(get_tree().create_timer(SPIN_LENGTH), "timeout")
		if animator["parameters/PlayerMovement/playback"].get_current_node() == "spin":
			animator["parameters/PlayerMovement/playback"].travel("end_spin")

func unspin():
	if spinning:
		max_velo = MAX_SPEED
		spinning = false
		power_stun(POST_SPIN_STUN)

##############################
# EXTERNAL NODE METHODS
####################

func spawn_bottle():
	var brewbottle = load("res://player/brewing/BrewingBottle.tscn")
	var bottle = brewbottle.instance()
	bottle.position = position - Vector2(direction*3, 0)
	bottle.init(direction)
	get_parent().add_child(bottle)

func get_direction():
	return direction

func set_velo(new_velo):
	velo = new_velo
func set_velo_x(x):
	velo.x = x
func set_velo_y(y):
	velo.y = y

func get_power_node():
	return $Power

func animate(animation):
	release_all_powers()
	animator["parameters/PlayerMovement/playback"].travel(animation)

func create_skid():
	if is_on_floor():
		var skid = preload("res://player/subscenes/skid.tscn").instance()
		skid.init(direction)
		skid.position += position + $ScaleChildren/hitbox/CollisionShape2D.position
		get_parent().add_child(skid)

func damage(isStomp, amount = 1):
	core.damage(isStomp, amount)
func heal(amount = 1):
	core.heal(amount)

onready var gravity_timer = get_node("GravityTimer")
func pause_gravity():
	gravity = false
	gravity_timer.start()
func resume_gravity():
	gravity = true
	gravity_timer.stop()
