tool
extends StaticBody2D

onready var animator = get_node("AnimationTree")
onready var pon = load("res://items/Pon.tscn")
onready var runnerhat = load("res://items/RunnerHat.tscn")
onready var brewhat = load("res://items/BrewingHat.tscn")

enum BlockState {BREAKABLE, BREAKABLE2, SOLID, ITEM_HAT}
enum Item { NONE, PON, RUNNER, BREWER }
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

func collide(collision, collidingBody):
	if collision.normal.y > 0:
		animator["parameters/playback"].travel("bop")
		match boxedItem:
			Item.PON:
				var defeatedMafia = pon.instance()
				defeatedMafia.set_position(Vector2(0, -16))
				add_child(defeatedMafia)
				defeatedMafia.collect(collidingBody)
			Item.RUNNER:
				var hat = runnerhat.instance()
				hat.set_position(Vector2(0, -16))
				hat.get_node("Body").velo.y = -150
				add_child(hat)
			Item.BREWER:
				var hat = brewhat.instance()
				hat.set_position(Vector2(0, -16))
				hat.get_node("Body").velo.y = -150
				add_child(hat)
		if state == BlockState.ITEM_HAT or boxedItem != Item.NONE:
			state = BlockState.SOLID
		elif state == BlockState.BREAKABLE or state == BlockState.BREAKABLE2:
			smash()
		if boxedItem != Item.NONE:
			boxedItem = Item.NONE
