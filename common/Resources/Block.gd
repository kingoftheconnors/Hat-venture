tool
extends StaticBody2D

onready var animator = get_node("AnimationTree")
onready var pon = load("res://items/Resources/Pon.tscn")
onready var runnerhat = load("res://items/Resources/RunnerHat.tscn")

enum BlockState {BREAKABLE, BREAKABLE2, SOLID, ITEM_HAT}
var prevBlockState
export(BlockState) var state
export(Resource) var boxedItem = null
onready var power = boxedItem.new() if boxedItem != null else null

func _process(delta):
	if prevBlockState != state:
		match state:
			BlockState.ITEM_HAT:
				$Sprite.frame = 0
			BlockState.SOLID:
				$Sprite.frame = 1
			BlockState.BREAKABLE:
				$Sprite.frame = 2
			BlockState.BREAKABLE2:
				$Sprite.frame = 2
		prevBlockState = state

func smash():
	animator["parameters/playback"].travel("smash")

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

func collide(collision, collidingBody):
	if collision.normal.y > 0 \
		and collision.travel.y < -0.25 \
		and collision.position.y >= global_position.y + 7.9 \
		and abs(global_position.x - collision.position.x) <= 8:
		hit(collidingBody)

func damage(isStomp):
	return hit(null)
