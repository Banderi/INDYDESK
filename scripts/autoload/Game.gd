extends Node

func debug_tools_enabled():
	return false

var wall_tiles : TileMap = null
func is_tile_obstructed(tile):
	var tile_id = wall_tiles.get_cellv(tile)
	if tile_id != -1:
		return true
	return false
