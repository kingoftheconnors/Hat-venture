extends TileMap

var collision_pos = []

func _on_Player_collided(player, collision):
	print(collision, self)
	# KinematicCollision2D object emitted by character
	if collision.collider == self:
		var tile_pos = collision.collider.world_to_map(player.position)
		tile_pos -= collision.normal  # Colliding tile
		var tile = collision.collider.get_cellv(tile_pos)
		if tile > 0:
			set_cellv(tile_pos, tile-1)
