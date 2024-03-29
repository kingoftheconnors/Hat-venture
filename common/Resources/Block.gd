# Script for controlling blocks. Players can destroy blocks by
# jumping below them (at any power level) or using several
# powers to destroy them. Blocks will not be destroyed if the
# boxedItem variable is set.
tool
extends StaticBody2D

onready var animator = $AnimationTree
onready var collider = $CollisionShape2D
onready var pon = load("res://items/Resources/Pon.tscn")
onready var runnerhat = load("res://items/Resources/RunnerHat.tscn")

enum BlockState {BREAKABLE, BREAKABLE2, SOLID, ITEM_HAT, HIDDEN}
var prevBlockState
## Block state. Used to set a block's graphic and state
export(BlockState) var state
## Item the box will release upon being hit. Is empty by default
export(Resource) var boxedItem = null

# Instanced version of boxedItem. Created when level starts
onready var power = boxedItem.new() if boxedItem != null else null
# Score points received when block is destroyed
const DEATH_SCORE = 10
export(int) var death_score = DEATH_SCORE

func _process(_delta):
	if prevBlockState != state:
		if !Engine.is_editor_hint():
			collider.disabled = false
		match state:
			BlockState.ITEM_HAT:
				$Sprite.frame = 0
			BlockState.SOLID:
				$Sprite.frame = 1
			BlockState.BREAKABLE:
				$Sprite.frame = 2
			BlockState.BREAKABLE2:
				$Sprite.frame = 2
			BlockState.HIDDEN:
				$Sprite.frame = 5
				if !Engine.is_editor_hint():
					collider.disabled = true
		prevBlockState = state

## Attack method used by players and projectiles when attacking
## any other node.
func damage(_isStomp):
	return hit(null)

## Handles block being attacked by player
func hit(collidingBody):
	animator["parameters/playback"].travel("bop")
	if power != null:
		var createdItem = power.spawnFromBox(collidingBody)
		call_deferred("add_child", createdItem)
		state = BlockState.SOLID
		power = null
	elif state == BlockState.BREAKABLE or state == BlockState.BREAKABLE2:
		smash()
		# Return true when block is destroyed
		return true
	# Return false for un-smashed blocks
	return false

## Destroys block
func smash():
	PlayerGameManager.add_score(death_score)
	animator["parameters/playback"].travel("smash")
	SoundSystem.start_sound(sound_system.SFX.BLOCK_BREAK)

## Signal function. Handles jumps by the player from below
func collide(collision, collidingBody):
	if collision.normal.y > 0 \
		and abs(collision.normal.y) > abs(collision.normal.x) \
		and collision.travel.y < -0.15 \
		and collision.position.y >= global_position.y + 7.9:
		hit(collidingBody)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") and state == BlockState.HIDDEN:
		if body.is_velo_up():
			hit(body)
