extends KinematicBody2D

signal off_cliff

# DEFAULT
const TURNOFF_SPEED = 20
const SPEED = 40
const ACCELERATION = 4
const DIVE_SPEED = 200
const MAX_SPEED = 120
export(int) var BOUNCE_FORCE = 300
export(float) var FALL_MULTIPLIER = 1.1
export(int) var JUMP_STRENGTH = 300

# DIVE
var diving = false
var dive_jump = true
export(float) var DIVE_FALL_MULTIPLIER = 0.85
export(int) var DIVE_OUT_STRENGTH = 175

# RUN
const MAX_RUNNING_SPEED = 200

# BASH
var can_bash = false
var bashing = false
const BASH_SPEED = 215
const BASH_ACCELERATION = 10

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

var _stun = 0
var frozen = false
var autoMoving = false
var crouching = false

var max_velo = MAX_SPEED
var velo = Vector2()

var jump_timer = 0
var coyoteTimer = 0
var climbing = false
var air_time = 0

var init_placed = false
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
func _physics_process(_delta):
	move()
	manage_flags()

func move():
	var horizontal = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var vertical = (Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	
	if frozen or diving:
		horizontal = 0; vertical = 0
	if crouching and is_on_floor() and !autoMoving:
		horizontal = 0
	if bashing:
		horizontal = direction
	
	# Friction (before moving so friction only applies when player is
	# standing still or going over conventional speeds)
	if (horizontal == 0 and !autoMoving) or (is_on_floor() and abs(velo.x) > max_velo):
		velo.x *= 0.86
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
	
	# Stun
	if _stun <= 0:
		# Basic movement
		velo.x = calc_direc(horizontal, velo.x)
		
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
	else:
		_stun -= 1
	
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
		reset_position()
		
	if position.x < camera.limit_left:
		position.x = camera.limit_left
	if position.x > camera.limit_right:
		position.x = camera.limit_right

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
	var moved_velo = move_and_slide(v, Vector2.UP)#_with_snap(velo, snap, Vector2.UP, true)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision and collision.collider.is_in_group("block"):
			collision.collider.collide(collision, self)
	return moved_velo

func push(direc):
	if ( velo.x * direc.x < 0 or abs(velo.x) < abs(direc.x) ):
		velo.x = direc.x
	if ( velo.y * direc.y < 0 or abs(velo.y) < abs(direc.y) ):
		velo.y = direc.y

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
	
	if jump_timer > 0:
		jump_timer -= 1
		if is_on_floor():
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
			holding_jump = true
			if is_on_floor() or coyoteTimer > 0 or climbing or (diving and dive_jump):
				jump()
			else:
				jump_timer = 10
		
		if event.is_action_released("ui_A"):
			if holding_jump and velo.y < 0:
				velo.y *= release_jump_damp
				#animator["parameters/playback"].travel("freefall")
			holding_jump = false
			jump_timer = 0
		
		# Don't allow crouching while automoving
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
		autoMoving = false
		dive_jump = false
		max_velo = MAX_SPEED
		velo.y = min(-DIVE_OUT_STRENGTH, velo.y)
	# Energy jump
	coyoteTimer = 0
	jump_timer = 0
	climbing = false
	#jump_sfx.play()
	animator["parameters/conditions/jumping"] = true
	animator["parameters/conditions/not_jumping"] = false

func start_run():
	max_velo = MAX_RUNNING_SPEED
	
func stop_run():
	max_velo = MAX_SPEED
	
func dive():
	if dive_jump and !diving:
		diving = true
		autoMoving = true
		max_velo = DIVE_SPEED
		push(Vector2(DIVE_SPEED * direction, -DIVE_SPEED/2))
		animator["parameters/playback"].travel("dive")

func bash():
	if !bashing and can_bash:
		can_bash = false
		bashing = true
		autoMoving = true
		crouching = false
		max_velo = BASH_SPEED
		velo = Vector2(direction * max_velo, 1)
		animator["parameters/playback"].travel("bash")

func upgrade_smash():
	if bashing:
		max_velo += BASH_ACCELERATION
		velo = Vector2(direction * max_velo, 1)
		animator["parameters/playback"].start("bash")

func unbash():
	if animator["parameters/playback"].get_current_node() == "bash":
		animator["parameters/playback"].start("end_bash")
	if velo.x > 0:
		velo.x = max(MAX_SPEED, velo.x - (max_velo - MAX_SPEED))
	else:
		velo.x = min(-MAX_SPEED, velo.x + (max_velo - MAX_SPEED))
	max_velo = MAX_SPEED
	bashing = false
	autoMoving = false
	# TODO: Set recharge

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
#
# EXTERNAL NODE METHODS
#
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

func get_animtor_node():
	return animator

func create_skid():
	if is_on_floor():
		var skid = preload("res://player/subscenes/skid.tscn").instance()
		skid.init(direction)
		skid.position += position + $ScaleChildren/hitbox/CollisionShape2D.position
		get_parent().add_child(skid)
