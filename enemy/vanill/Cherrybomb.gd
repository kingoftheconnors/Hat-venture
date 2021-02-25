# Damaging enemy projectile that can hurt player. Explodes after hitting
# anything
extends Node2D

const FALLING_BODY_GRAVITY = 11
var velo = Vector2()
var gravityMultiplier = 0.75
var moving = true
var creator : Node = null

func init(direc, creator_node):
	velo.x = 150 * direc
	velo.y = -200
	creator = creator_node

func _physics_process(delta):
	if moving:
		position += velo * delta
		velo.y += FALLING_BODY_GRAVITY * 50 * delta

onready var animation_player = $AnimationPlayer

func _on_Area2D_body_entered(body):
	# Colliding with tiles
	if body != creator:
		animation_player.play("disable")
		emit_signal("explode")
		moving = false

func _ready():
	animation_player.play("fly")

signal explode
