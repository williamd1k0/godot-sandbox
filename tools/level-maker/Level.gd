extends Node2D

onready var tilemap = get_node("TileMap")

func add(id, gpos):
	tilemap.set_cellv(
		tilemap.world_to_map(gpos), id
	)

func remove(gpos):
	tilemap.set_cellv(
		tilemap.world_to_map(gpos), -1
	)

func _on_Cursor_add( item, globalpos ):
	tilemap.set_cellv(
		tilemap.world_to_map(globalpos), item.id
	)

func _on_Cursor_remove( globalpos ):
	tilemap.set_cellv(
		tilemap.world_to_map(globalpos), -1
	)
