# Tilemap script that instances block tiles when level starts.
# This is required for blocks to give powers and be breakable,
# but is not needed for horizon or cloud tilemaps.
extends TileMap

var node_PlaceholderReplacer = preload("res://common/Block.tscn")

func _ready():
	var sizex = get_cell_size().x
	var sizey = get_cell_size().y
	var ts = get_tileset()
	var uc = get_used_cells()
	for pos in uc :
		var id = get_cell(pos.x, pos.y)
		var name:String = ts.tile_get_name(id)
		if  "Block" in name:
			var node = node_PlaceholderReplacer.instance()
			node.position = (Vector2( pos.x * sizex + (0.5*sizex), pos.y * sizey + (0.5*sizey)))
			# Fill with power
			if "Running" in name:
				node.boxedItem = preload("res://items/runningPower.gd")
			elif "Brewing" in name:
				node.boxedItem = preload("res://items/brewingPower.gd")
			elif "Hard" in name:
				node.boxedItem = preload("res://items/hardPower.gd")
			elif "Pon" in name:
				node.boxedItem = preload("res://items/pon.gd")
			elif "Spinning" in name:
				node.boxedItem = preload("res://items/thorPower.gd")
			# Make special or breakable
			if "Breakable" in name:
				node.state = node.BlockState.BREAKABLE
			add_child(node)
			set_cell(pos.x, pos.y, -1) #this line remove the tile in TileMap
