extends KinematicBody2D

signal off_cliff

# DEFAULT
const TURNOFF_SPEED = 15
const SPEED = 40
const ACCELERATION = 4
const DIVE_SPEED = 200
const SUPERDIVE_SPEED = 275
const MAX_SPEED = 117
export(int) var BOUNCE_FORCE = 300
export(float) var FALL_MULTIPLIER = 1.1
export(int) var JUMP_STRENGTH = 300

# DIVE
var diving = false
var dive_jump = true
var superdive_window = false
export(float) var DIVE_FALL_MULTIPLIER = 0.85
export(int) var DIVE_OUT_STRENGTH = 175

# RUN
const MAX_RUNNING_SPEED = 200
const RUN_JUMP_SPEED = 275

# BASH
var can_bash = false
var bashing = false
var bashing_combo = false
const BASH_SPEED = 215
const BASH_ACCELERATION = 10
const KNOCKBACK_MULTIPLIER = 250
const POST_BASH_STUN = 6

# CLIMBING
export(int) var CLIMBING_SPEED = 200
export(int) var WALL_CLIMBING_SPEED = 150
export(bool) var wall_climbing = false

# Sound effects
#onready var jump_sfx = get_node("SoundJump")
onready var scale_manager = get_node("ScaleChildren")
onready var animator = get_node("AnimationTree")
onready var animatorPlayer = get_node("AnimationPlayer")
onready var camera = get_node("../Camera2D")
onready var core = get_node("ScaleChildren/PlayerCore")

onready var skidRayCast1 = get_node("SkidRay")
onready var skidRayCast2 = get_node("SkidRay2")

# Movement vars
var _stun = 0
var frozen = false
var speeding = false
var crouching = false

var max_velo = MAX_SPEED
var velo = Vector2()

var jump_timer = 0
var coyoteTimer = 0
var climbing = false
var air_time = 0
var skid_perfect = false

# Initial spawn for players dying. An educated guess for a legal, safe position
var cur_spawn = Vector2()

export(float) var release_jump_damp = 0.4

var direction = 1

export var on_ladders = 0

func reset_position():
	position = cur_spawn
	velo = Vector2()

func set_spawn(pos):
	cur_spawn = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move(delta)
	manage_flags()

func move(delta):
	var horizontal = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var vertical = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	
	if _stun > 0:
		horizontal = 0
		vertical = 0
		_stun -= 1
	
	if frozen or diving:
		horizontal = 0; vertical = 0
	if crouching and is_on_floor():
		horizontal = 0
	if bashing:
		horizontal = direction
	
	# Friction (before moving so friction only applies when player is
	# standing still or going over conventional speeds)
	if (horizontal == 0 and !speeding) or (is_on_floor() and abs(velo.x) > max_velo):
		velo.x *= 0.87
	elif diving: # Diving friction
		if is_on_floor():
			velo.x *= 0.93
	
	# Setting direction
	if horizontal * direction < 0:
		if horizontal > 0:
			direction = 1
		else:
			direction = -1
		scale_manager.scale = Vector2(direction, 1)

	# Basic movement
	if bashing:
		velo = Vector2(direction * max_velo, 0)
	else:
		velo.x = calc_direc(horizontal, velo.x)
	
	# Skid perfect
	if skid_perfect and is_on_floor():
		if !skidRayCast1.is_colliding() or !skidRayCast2.is_colliding():
			velo.x *= 0.86
	
	# Animating
	if horizontal != 0:
		animator["parameters/conditions/walking"] = true
		animator["parameters/conditions/not_walking"] = false
		animator["parameters/run/TimeScale/scale"] = .5 + abs(velo.x)/MAX_RUNNING_SPEED
	else:
		animator["parameters/conditions/walking"] = false
		animator["parameters/conditions/not_walking"] = true
	
	if velo.x * horizontal < 0:
		animator["parameters/conditions/skidding"] = true
		animator["parameters/conditions/not_skidding"] = false
	else:
		animator["parameters/conditions/skidding"] = false
		animator["parameters/conditions/not_skidding"] = true
	
	if diving:
		if is_on_floor():
			animator["parameters/conditions/dive_resting"] = true
			animator["parameters/conditions/not_dive_resting"] = false
		else:
			animator["parameters/conditions/dive_resting"] = false
			animator["parameters/conditions/not_dive_resting"] = true
	
	#Gravity
	if !climbing and !frozen and !bashing:
		if velo.y < 0:
			velo.y += Constants.gravity
		else:
			if diving:
				velo.y += Constants.gravity * DIVE_FALL_MULTIPLIER
			else:
				velo.y += Constants.gravity * FALL_MULTIPLIER
			# terminal velocity
			if velo.y > Constants.terminalVelocity:
				velo.y = Constants.terminalVelocity
	
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
	if !frozen:
		velo = move_player(velo)
	
	if position.y > camera.limit_bottom:
		emit_signal("off_cliff")
		
	if position.x < camera.limit_left:
		position.x = camera.limit_left
		velo.x = max(0, velo.x)
	if position.x > camera.limit_right:
		position.x = camera.limit_right
		velo.x = min(0, velo.x)

func calc_direc(ui_direc, cur_speed, speed = SPEED):
	if ui_direc > 0 and cur_speed >= ui_direc*SPEED*.9: # Accelerate right
		return max(cur_speed, min(cur_speed + ui_direc*ACCELERATION, max_velo))
	elif ui_direc > 0 and cur_speed > -ui_direc*TURNOFF_SPEED: # On low speed, set to base speed instantly
		return max(cur_speed, ui_direc*speed)
	elif ui_direc < 0 and cur_speed <= ui_direc*SPEED*.9: # Accelerate left
		return min(cur_speed, max(cur_speed + ui_direc*ACCELERATION, -max_velo))
	elif ui_direc < 0 and cur_speed < -ui_direc*SPEED: # On low speed, set to base speed instantly
		return min(cur_speed, ui_direc*speed)
	elif ui_direc != 0:  # Sliding for when velo is launched out of regular range (and attempting to turn back)
		return cur_speed + ui_direc*ACCELERATION
	elif ui_direc == 0 and abs(cur_speed) <= TURNOFF_SPEED:  # Hard stop on release
		return 0
	else:
		return cur_speed

func move_player(v):
	#var snap = Vector2.DOWN * 16 if is_on_floor() and !just_jumped else Vector2.ZERO
	var prev_velo = v
	var new_velo = move_and_slide(v, Vector2.UP)#_with_snap(velo, snap, Vector2.UP, true)
	var recognize_collision = true
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if !collision.collider.is_in_group("Player"):
			# Special cases when hitting level tiles
			if collision.collider.get_collision_layer_bit(1) == true:
				# Corner correction
				if collision.local_shape.get_name() == "HeadCollider":
					if collision.position.y > collision.local_shape.global_position.y - collision.local_shape.shape.radius + .15:
						# Push sideways and set recognize_collision to false
						recognize_collision = false
						if collision.position.x < global_position.x:
							position.x += 1
						else:
							position.x -= 1
				# Hitting blocks
				if recognize_collision:
					if collision and collision.collider.is_in_group("block"):
						collision.collider.collide(collision, self)
	if !recognize_collision:
		new_velo = prev_velo
	if bashing:
		new_velo.y = 0
	return new_velo

onready var bash_collider = get_node("ScaleChildren/bashbox/BashCollider")
func bash_bounce(body):
	# Special cases when bashing
	#if bashing and abs(collision.normal.x) > abs(collision.normal.y):
	var destroyedBody = core.bash(body)
	# Smashing through an object (disabling its collision)
	if destroyedBody:
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
		var upperHit = space_state.intersect_ray(topPos, topPos+Vector2(20*direction, 0), [], 2)
		if upperHit:
			#rint("Upper hit")
			for i in range(12):
				var result = space_state.intersect_ray(topPos+Vector2(0, i), topPos+Vector2(20*direction, i), [], 2)
				if !result:
					recognize_collision = false
					position.y += i
					break
		# Test corner correction upwards
		var lowerHit = space_state.intersect_ray(bottomPos, bottomPos+Vector2(20*direction, 0), [], 2)
		if lowerHit:
			#print("Lower hit")
			for i in range(12):
				var result = space_state.intersect_ray(bottomPos+Vector2(0, -i), bottomPos+Vector2(20*direction, -i), [], 2)
				if !result:
					recognize_collision = false
					print(i)
					position.y -= i
					break
		if recognize_collision:
			# No corner correction, bounce off
			var direc = Vector2(-direction, -0.5) * KNOCKBACK_MULTIPLIER
			velo = push(direc)
			unbash()

func push(direc):
	var pushed_velo = velo
	if ( velo.x * direc.x < 0 or abs(velo.x) < abs(direc.x) ):
		pushed_velo.x = direc.x
	if ( velo.y * direc.y < 0 or abs(velo.y) < abs(direc.y) ):
		pushed_velo.y = direc.y
	return pushed_velo

func manage_flags():
	if is_on_floor() or climbing:
		refresh_flags()
	else:
		if !air_time:
			air_time = true
		if coyoteTimer > 0:
			coyoteTimer -= 1
	
	if is_on_floor() and air_time:
		air_time = false
		animator["parameters/conditions/jumping"] = false
		animator["parameters/conditions/not_jumping"] = true
	
	if is_on_floor() and speeding and !bashing and !diving:
		speeding = false
	
	if jump_timer > 0:
		jump_timer -= 1
		if _stun <= 0 \
			and (is_on_floor() \
				or coyoteTimer > 0 \
				or climbing \
				or (diving and dive_jump)):
			jump()

func refresh_flags():
	if coyoteTimer < 5:
		coyoteTimer = 5
	if !dive_jump:
		dive_jump = true
	if !can_bash:
		can_bash = true

var holding_jump = false

func _unhandled_input(event):
	if !frozen:
		# This will run once on the frame when the action is first pressed
		if event.is_action_pressed("ui_A"):
			if !bashing:
				holding_jump = true
				jump_timer = 10
		
		if event.is_action_released("ui_A"):
			if holding_jump and velo.y < 0:
				velo.y *= release_jump_damp
				#animator["parameters/playback"].travel("freefall")
			holding_jump = false
			jump_timer = 0
		
		if event.is_action_pressed("ui_crouch"):
			crouching = true
			animator["parameters/playback"].travel("crouch")
			animator["parameters/conditions/crouching"] = true
			animator["parameters/conditions/not_crouching"] = false
		
		if event.is_action_released("ui_crouch"):
			crouching = false
			animator["parameters/conditions/crouching"] = false
			animator["parameters/conditions/not_crouching"] = true

func jump():
	# Basic Jump
	if !diving:
		velo.y = min(-JUMP_STRENGTH, velo.y)
	# Out-of-dive Jump
	if diving:
		diving = false
		#speeding = false
		dive_jump = false
		max_velo = MAX_SPEED
		velo.y = min(-DIVE_OUT_STRENGTH, velo.y)
		if superdive_window:
			velo = Vector2(direction * SUPERDIVE_SPEED, -SUPERDIVE_SPEED)
	# Energy jump
	coyoteTimer = 0
	jump_timer = 0
	climbing = false
	#jump_sfx.play()
	animator["parameters/conditions/jumping"] = true
	animator["parameters/conditions/not_jumping"] = false

func bounce():
	var direc = Vector2(0, -BOUNCE_FORCE)
	if !holding_jump:
		direc *= release_jump_damp
	
	if ( velo.x * direc.x < 0 or abs(velo.x) < abs(direc.x) ):
		velo.x = direc.x
	if ( velo.y * direc.y < 0 or abs(velo.y) < abs(direc.y) ):
		velo.y = direc.y
	refresh_flags()

func get_stun():
	return _stun

func stun(amo, stun_mult = 3):
	_stun = amo * stun_mult

func set_freeze(flag):
	frozen = flag


##############################
# STATE METHODS
####################

func dive():
	if dive_jump and !diving:
		diving = true
		speeding = true
		max_velo = DIVE_SPEED
		velo = push(Vector2(DIVE_SPEED * direction, -DIVE_SPEED/2))
		animator["parameters/playback"].travel("dive")

func superdive_active():
	superdive_window = true
func superdive_inactive():
	superdive_window = false

func start_run():
	max_velo = MAX_RUNNING_SPEED
func stop_run():
	max_velo = MAX_SPEED

func start_skid_perfect():
	skid_perfect = true
func stop_skid_perfect():
	skid_perfect = false

func bash():
	if !bashing and can_bash and _stun <= 0:
		can_bash = false
		bashing = true
		crouching = false
		max_velo = BASH_SPEED
		animator["parameters/playback"].travel("bash")

func upgrade_smash():
	if bashing:
		max_velo += BASH_ACCELERATION
		velo = Vector2(direction * max_velo, 1)
		animator["parameters/playback"].start("bash")
		bashing_combo = true

func unbash():
	if bashing:
		if velo.x > max_velo:
			velo.x = max(MAX_SPEED, velo.x - (max_velo - MAX_SPEED))
		elif velo.x < -max_velo:
			velo.x = min(-MAX_SPEED, velo.x + (max_velo - MAX_SPEED))
		max_velo = MAX_SPEED
		bashing = false
		if bashing_combo == false:
			stun(POST_BASH_STUN)
		bashing_combo = false
		# TODO: Set recharge


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

func get_power_node():
	return $Power

func get_animator_node():
	return animator

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
