extends Sprite

## Power of checkpoint. Higher valued checkpoints are spawned at when
## the player dies
export(int, 0, 100) var checkpoint_priority = 0

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if !is_active:
			PlayerGameManager.checkpoint(checkpoint_priority, position)
			is_active = true
			animation_player.play("checkpoint")

var is_active = false
onready var animation_player = $AnimationPlayer
