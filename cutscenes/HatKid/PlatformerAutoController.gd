extends KinematicBody2D

signal off_cliff
signal dead
signal landed_on_ground

# BASIC MOVEMENT
const PLAYER_GRAVITY = 10
const FALL_UP_GRAVITY = 5
const TURNOFF_SPEED = 15
const BASE_SPEED = 10 #25
var base_speed = BASE_SPEED
const ACCELERATION = 5
const MAX_SPEED = 93
const COYOTE_TIME = 5
var BOUNCE_FORCE := 300
var FALL_MULTIPLIER : float = 1.1
var JUMP_STRENGTH := 275

# DIVE
var diving = false
var can_superdive = false
var can_dive : int = 1
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
const KNOCKBACK_MULTIPLIER = 140

# POWERS
var power_stun_frames = 0
var can_use_power = true

# RUN
const WALLJUMP_SPEED = 230
const RUN_ACCELERATION = 12
const RUN_SKID_ACCELERATION = 4
const RUN_DELAY_START_SPEED = 30
var running
var wallslide_friction_rate = 0
const WALLSLIDE_FRICTION_START = 0.83
const WALLSLIDE_FRICTION_END = 0.93
const WALLSLIDE_CHANGE_RATE = 0.07

# Sound effects
onready var scale_manager = $"ScaleChildren"
onready var animator = $"AnimationTree"
onready var animatorPlayer = $"AnimationPlayer"
onready var camera = $"../Camera"
onready var cliffRaycast = $ScaleChildren/PlayerCore/RayCast2D

# Movement vars
var _stun = 0
var frozen = false
var suspended = false
var ignore_air_friction = false
var ignore_horizontal_timer = 0
var crouching = false
var gravity = true

var goal_x = null
var goal_y = null
var direc_override = null
var watch_override = null
const WALK_EPSILON : float = 1.0

## Current velo. Similar to other platformers, starts at 0 and ramps up
## to max_velo
var velo = Vector2()
## The current goal velo ramps up to; the velo the player will usually
## be at when moving
var max_velo = MAX_SPEED
## Max velo when player is moving without any other impulses or effects.
## Can be walk-speed or run-speed based on equipped power
var default_max_velo = MAX_SPEED

var jump_timer = 0
const JUMP_TIME = 10
var coyoteTimer = 0
var air_time = 0
var skid_perfect = false
var lookahead = 0

# Initial spawn for players dying. An educated guess for a legal, safe position
var cur_spawn = Vector2()

var release_jump_damp : float = 0.4

var direction = 1
var prev_horizontal = 0

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
var falling = true
func _physics_process(delta):
	if falling and is_on_floor():
		falling = false
	if is_on_wall() or (is_on_floor() and not cliffRaycast.is_colliding()):
		jump_timer = JUMP_TIME
	move(delta)
	manage_flags()

## Calculates velocity and moves player
func move(delta):
	var horizontal = 0
	if !falling:
		horizontal = 1
	var vertical = 0
	
	if ignore_horizontal_timer > 0 and horizontal * direction < 0:
		horizontal = -horizontal
	
	if _stun > 0:
		horizontal = 0
		vertical = 0
		_stun -= 1
	
	if frozen or diving:
		horizontal = 0; vertical = 0
	
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
	
	# Creating skid dash at beginning of sprint
	if running and horizontal != 0 and is_on_floor() and prev_horizontal == 0:
		run_start_effect()
	prev_horizontal = horizontal
	
	if (horizontal == 0 and !ignore_air_friction and !is_on_floor()):
		velo.x *= 0.87
	elif (horizontal == 0 and !crouching and is_on_floor()):
		velo.x *= 0.87
	elif diving: # Diving friction
		if is_on_floor():
			velo.x *= 0.93
	elif crouching and is_on_floor():
		velo.x *= 0.96
	
	# Wall sliding while run power is active
	if running and horizontal * prev_horizontal > 0 and is_on_wall() and velo.y > 0:
		# On first wallslide frame, cut velo extra
		if animator["parameters/PlayerMovement/conditions/wallsliding"] == false:
			wallslide_friction_rate = WALLSLIDE_FRICTION_START
			velo.y *= 0.1
		elif wallslide_friction_rate < WALLSLIDE_FRICTION_END:
			wallslide_friction_rate += WALLSLIDE_CHANGE_RATE * delta
		velo.y *= wallslide_friction_rate
		print(wallslide_friction_rate, " - ", delta)
		animate("wallslide")
		animator["parameters/PlayerMovement/conditions/wallsliding"] = true
		animator["parameters/PlayerMovement/conditions/not_wallsliding"] = false
	else:
		animator["parameters/PlayerMovement/conditions/wallsliding"] = false
		animator["parameters/PlayerMovement/conditions/not_wallsliding"] = true
	# Basic movement
	if running and horizontal != 0:
		if direction * velo.x <= 0:
			velo.x = calc_direc(direction, velo.x, RUN_SKID_ACCELERATION)
		else:
			velo.x = calc_direc(direction, velo.x, RUN_ACCELERATION)
	else:
		velo.x = calc_direc(horizontal, velo.x, ACCELERATION)
	
	# Animating
	if horizontal != 0:
		animator["parameters/PlayerMovement/conditions/walking"] = true
		animator["parameters/PlayerMovement/conditions/not_walking"] = false
		animator["parameters/PlayerMovement/walk/4/blend_position"] = abs(velo.x)/max_velo
		animator["parameters/PlayerMovement/walk/4/1/Speed/scale"] = .5 + abs(velo.x)/max_velo
	else:
		animator["parameters/PlayerMovement/conditions/walking"] = false
		animator["parameters/PlayerMovement/conditions/not_walking"] = true
	
	if velo.x * horizontal < 0:
		animator["parameters/PlayerMovement/conditions/skidding"] = true
		animator["parameters/PlayerMovement/conditions/not_skidding"] = false
	else:
		animator["parameters/PlayerMovement/conditions/skidding"] = false
		animator["parameters/PlayerMovement/conditions/not_skidding"] = true
	
	# Running sound
	if running:
		if is_running_at_max():
			SoundSystem.start_sound_if_silent(sound_system.SFX.SPRINT)
		else:
			SoundSystem.stop_if_playing_sound(sound_system.SFX.SPRINT)
	
	if diving:
		if is_on_floor():
			animator["parameters/PlayerMovement/conditions/dive_resting"] = true
			animator["parameters/PlayerMovement/conditions/not_dive_resting"] = false
		else:
			animator["parameters/PlayerMovement/conditions/dive_resting"] = false
			animator["parameters/PlayerMovement/conditions/not_dive_resting"] = true
	
	#Gravity
	if gravity:
		if goal_y != null:
			velo.y *= .98
			if position.y < goal_y:
				velo.y += FALL_UP_GRAVITY
			else:
				velo.y -= FALL_UP_GRAVITY
		else:
			if velo.y < 0:
				velo.y += PLAYER_GRAVITY
			else:
				if running and velo.x > max_velo*.75 and coyoteTimer > 0:
					pass
				elif diving:
					velo.y += PLAYER_GRAVITY * DIVE_FALL_MULTIPLIER
				else:
					velo.y += PLAYER_GRAVITY * FALL_MULTIPLIER
				# terminal velocity
				if velo.y > Constants.terminalVelocity:
					velo.y = Constants.terminalVelocity
	
	# Apply Movement
	if !suspended:
		velo = move_player(velo)
	
	if position.y > camera.lim_bottom + 20:
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

onready var feetCollider = $"FeetCollider"
func move_player(v):
	var snap = Vector2.DOWN if is_on_floor() else Vector2.ZERO
	var prev_velo = v
	var new_velo = move_and_slide_with_snap(v, snap, Vector2.UP, false, 4, 0.785, false) #(v, Vector2.UP)#
	var recognize_collision = true
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision != null:
			if !collision.collider.is_in_group("player"):
				# Special cases when hitting level tiles
				if collision.collider.get_collision_layer_bit(1) == true:
					# Corner correction
					if collision.local_shape.get_name() == "HeadCollider":
						if collision.position.y > collision.local_shape.global_position.y \
							- collision.local_shape.shape.radius - collision.local_shape.shape.height/2 + 0.11 \
							and collision.position.y < collision.local_shape.global_position.y \
							 + collision.local_shape.shape.radius + collision.local_shape.shape.height/2 - 0.25:
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
	if !recognize_collision:
		new_velo = prev_velo
	#if bashing:
	#	new_velo.y = 0
	return new_velo

func teleport_to(node_path : String):
	position = get_node(node_path).position

func walk_to(node_path : String, direction_override = null):
	goal_x = get_node(node_path).position.x
	if direction_override:
		direc_override = direction_override
func fly_to(node_path : String):
	goal_y = get_node(node_path).position.y
func watch_node(node_path: String):
	watch_override = get_node(node_path)
func stop_watching():
	watch_override = null

func bounce_back(towards_x = null):
	var direc = Vector2(-direction, -1.1) * KNOCKBACK_MULTIPLIER
	if towards_x != null:
		if (get_node(towards_x).position.x - position.x) * direc.x < 0:
			direc.x = -direc.x
		# Walk towards target area, with direction override opposite walk_direction
		walk_to(towards_x, -direc.x/abs(direc.x))
	push(direc)

func bounce_towards(direc : int = direction):
	push(Vector2(direc, -0.8) * KNOCKBACK_MULTIPLIER)

func push(direc):
	if ( velo.x * direc.x < 0 or abs(velo.x) < abs(direc.x) ):
		velo.x = direc.x
	if ( velo.y * direc.y < 0 or abs(velo.y) < abs(direc.y) ):
		velo.y = direc.y

## Processing function called once per frame that tracks all bit timers
## and state flags for the player
func manage_flags():
	if is_on_floor():
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
		emit_signal("landed_on_ground")
		air_time = false
		PlayerGameManager.set_multiplicity_fast_decrease(true)
		animator["parameters/PlayerMovement/conditions/jumping"] = false
		animator["parameters/PlayerMovement/conditions/not_jumping"] = true
		if running:
			run_start_effect()
	
	if is_on_floor() and ignore_air_friction:
		if !diving and abs(velo.x) < max_velo*.8:
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
	if ignore_horizontal_timer > 0:
		ignore_horizontal_timer -= 1
	
	if jump_timer > 0:
		jump_timer -= 1
		if _stun <= 0 \
			and (is_on_floor() \
				or coyoteTimer > 0 \
				or diving \
				or (running and wall_jump_checker.is_colliding())):
			jump()

func refresh_flags():
	if coyoteTimer < COYOTE_TIME:
		coyoteTimer = COYOTE_TIME
	refresh_dive()

func refresh_dive():
	if can_dive < PlayerGameManager.dive_num:
		can_dive = PlayerGameManager.dive_num

var holding_jump = false

onready var wall_jump_checker : RayCast2D = $"ScaleChildren/WallJumpChecker"
func jump(minijump : bool = false):
	# Jump sfx
	#if velo.y >= 0:
	#	SoundSystem.start_sound(sound_system.SFX.JUMP)
	# Set jump speed
	if running and wall_jump_checker.is_colliding() and !is_on_floor():
		# Walljump
		direction = wall_jump_checker.get_collision_normal().x
		push(Vector2(direction * WALLJUMP_SPEED, -WALLJUMP_SPEED))
		animator["parameters/PlayerMovement/playback"].travel("dive_boost")
		animator['parameters/PlayerEffect/playback'].travel('walljumpInvincibility')
		ignore_air_friction = true
		ignore_horizontal_timer = 10
		if diving:
			undive()
		refresh_dive()
	elif minijump:
		push(Vector2(0, -DIVE_OUT_STRENGTH))
	elif !diving: # Basic Jump
		push(Vector2(0, -JUMP_STRENGTH))
	else: # Out-of-dive Jump
		undive()
		if velo.x > 0:
			velo.x = min(DIVE_OUT_SPEED, velo.x)
		else:
			velo.x = max(-DIVE_OUT_SPEED, velo.x)
		push(Vector2(0, -DIVE_OUT_STRENGTH))
		if (superdive_timer > 0) or (!is_on_floor() and move_and_collide(Vector2(0, DIVE_MERCY), true, true, true)):
			push(Vector2(direction * SUPERDIVE_SPEED, -SUPERDIVE_SPEED))
			animator["parameters/PlayerMovement/playback"].travel("dive_boost")
			refresh_flags()
		if (mini_superdive_timer > 0):
			push(Vector2(direction * SUPERDIVE_SPEED, -SUPERDIVE_SPEED))
			animator["parameters/PlayerMovement/playback"].travel("dive_boost")
			refresh_flags()
	# Energy jump
	coyoteTimer = 0
	jump_timer = 0
	animate_jump()

## Bounces player upwards (used when stepping on enemy or spring)
func bounce(multiplier = 1):
	var direc = Vector2(0, -BOUNCE_FORCE * multiplier)
	if !holding_jump:
		direc *= release_jump_damp
	push(direc)
	if diving and can_superdive:
		superdive_timer = SUPERDIVE_TIME
	refresh_flags()

func animate_jump():
	animator["parameters/PlayerMovement/conditions/jumping"] = true
	animator["parameters/PlayerMovement/conditions/not_jumping"] = false


func get_stun():
	return _stun

func release_all_powers():
	if diving:
		animator["parameters/PlayerMovement/playback"].start("end_dive")
		undive()

func stun(amo, stun_mult = 3):
	_stun = amo * stun_mult
	release_all_powers()

func power_stun(amo, animate = true):
	if animate:
		if !Constants.PHOTOSENSITIVE_MODE:
			animator["parameters/PlayerEffect/playback"].travel("powerlessFlash")
		animator["parameters/PlayerEffect/conditions/powerless_off"] = false
	power_stun_frames = amo
	
func power_stun_frame():
	if power_stun_frames > 0:
		match PlayerGameManager.power_speed:
			PlayerGameManager.PowerDelay.FAST:
				power_stun_frames -= 2
			PlayerGameManager.PowerDelay.INSTANT:
				power_stun_frames = 0
			_:
				power_stun_frames -= 1
		if power_stun_frames <= 0:
			animator["parameters/PlayerEffect/conditions/powerless_off"] = true
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
	if can_dive > 0 and !diving:
		can_dive -= 1
		diving = true
		ignore_air_friction = true
		max_velo = DIVE_SPEED
		velo = Vector2(DIVE_SPEED * direction, -DIVE_SPEED*0.75)
		animator["parameters/PlayerMovement/playback"].travel("dive")
		animator["parameters/PlayerMovement/conditions/jumping"] = false
		animator["parameters/PlayerMovement/conditions/not_jumping"] = true
		SoundSystem.start_sound(sound_system.SFX.DIVE)
func undive():
	diving = false
	max_velo = default_max_velo

func crouch():
	crouching = true
	animator["parameters/PlayerMovement/conditions/crouching"] = true
	animator["parameters/PlayerMovement/conditions/not_crouching"] = false
func uncrouch():
	crouching = false
	animator["parameters/PlayerMovement/conditions/crouching"] = false
	animator["parameters/PlayerMovement/conditions/not_crouching"] = true

func start_run(running_speed):
	default_max_velo = running_speed
	max_velo = default_max_velo
	running = true
func stop_run():
	SoundSystem.stop_if_playing_sound(sound_system.SFX.SPRINT)
	default_max_velo = MAX_SPEED
	max_velo = default_max_velo
	running = false

func start_skid_perfect():
	skid_perfect = true
func stop_skid_perfect():
	skid_perfect = false

func set_climb_speed(flag : bool):
	if flag:
		animator["parameters/PlayerMovement/climb/rate/scale"] = 1
	else:
		animator["parameters/PlayerMovement/climb/rate/scale"] = 0


##############################
# EXTERNAL NODE METHODS
####################

func on_ladder(ladder):
	pass
func off_ladder():
	pass
func on_ladder_top(ladder):
	pass
func off_ladder_top(ladder):
	pass

func get_direction():
	return direction

func is_running_at_max():
	return running and abs(velo.x) > max_velo * .95

func set_lookahead(new_lookahead = 0):
	lookahead = new_lookahead

func set_velo(new_velo):
	velo = new_velo
func set_velo_x(x):
	velo.x = x
func set_velo_y(y):
	velo.y = y
func is_velo_up() -> bool:
	return velo.y < 0

func animate(animation):
	release_all_powers()
	animator["parameters/PlayerMovement/playback"].travel(animation)

func create_skid(play_sfx : bool = false, x_offset = 0):
	if is_on_floor():
		var skid = preload("res://player/subscenes/skid.tscn").instance()
		skid.init(direction)
		skid.position += position
		skid.position.x += x_offset
		get_parent().add_child(skid)
		if play_sfx:
			SoundSystem.start_sound(sound_system.SFX.SKID, abs(velo.x/max_velo))
			#SoundSystem.start_sound(sound_system.SFX.SKID)

func run_start_effect():
	create_skid(false, 7)
	create_skid(false, 0)
	create_skid(false, -7)

func signal_death():
	emit_signal("dead")
	SoundSystem.start_music(sound_system.MUSIC.GAMEOVER)
func heal(amount = 1):
	pass

onready var gravity_timer = $"GravityTimer"
func pause_gravity():
	gravity = false
	gravity_timer.start()
func resume_gravity():
	gravity = true
	gravity_timer.stop()

func dance_fx():
	SoundSystem.start_music(sound_system.MUSIC.VICTORY)
