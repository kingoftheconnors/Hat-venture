tool
extends StaticBody2D

onready var animator = get_node("AnimationTree")
onready var pon = load("res://Common/Pon.tscn")

enum BlockState {BREAKABLE, BREAKABLE2, SOLID, ITEM_HAT}
enum Item { NONE, PON, RUNNER }
var prevBlockState
export(BlockState) var state
export(Item) var boxedItem = Item.NONE

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

func collide(collision):
	if collision.normal.y > 0:
		animator["parameters/playback"].travel("bop")
		match boxedItem:
			Item.PON:
				var collect = pon.instance()
				collect.set_position(Vector2(0, -16))
				collect.collide()
				add_child(collect)
			Item.RUNNER:
				pass
		if state == BlockState.ITEM_HAT or boxedItem != Item.NONE:
			state = BlockState.SOLID
		elif state == BlockState.BREAKABLE or state == BlockState.BREAKABLE2:
			smash()
