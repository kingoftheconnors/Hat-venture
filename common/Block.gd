tool
extends StaticBody2D

onready var animator = get_node("AnimationTree")
onready var pon = load("res://items/Pon.tscn")
onready var runnerhat = load("res://items/RunnerHat.tscn")

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
				$Sprite.frame = 3
		prevBlockState = state

func smash():
	queue_free()

func collide(collision, collidingBody):
	if collision.normal.y > 0:
		animator["parameters/playback"].travel("bop")
		if power != null:
			var createdItem = power.spawnFromBox(collidingBody)
			add_child(createdItem)
			state = BlockState.SOLID
			power = null
		elif state == BlockState.BREAKABLE or state == BlockState.BREAKABLE2:
			smash()
