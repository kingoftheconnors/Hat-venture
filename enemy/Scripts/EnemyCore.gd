# Enemy core script.
# Manages:
#	Health
#   Death
# REQUIREMENT: All enemies should have a hurtbox with a radius
# of at least radius 3
extends Node

signal hurt
onready var animator = get_node_or_null("AnimationTree")

## Damage enemy does to player
export(int) var damage = 1
## Score-points player gets for defeating this enemy
export(int) var death_score = 100
## Invincibility. Useful for making an enemy
## bounce-off-able but still unkillable
export(bool) var invincible = false

## Gets damage this enemy does to the player
func get_damage():
	return damage

## Attack method used by players and projectiles when attacking
## any other node.
func damage(isStomp):
	if !invincible:
		emit_signal("hurt")
		if animator:
			if isStomp:
				animator["parameters/playback"].travel("smash")
			else:
				animator["parameters/playback"].travel("die")
		# Dead, so always true
		return true
	# If invincible, return false
	return false

## Processes required ceremony after an enemy is first killed
func register_death():
	#var score_fx = preload("res://common/Block.tscn")
	PlayerGameManager.add_score(death_score, true)

## Function to finalize an enemy's death. Removes enemy from screen
func die():
	get_parent().visible = false
	death_score = 0

## Root node function for animating enemy sprite
func animate(animation_name):
	animator["parameters/playback"].travel(animation_name)
