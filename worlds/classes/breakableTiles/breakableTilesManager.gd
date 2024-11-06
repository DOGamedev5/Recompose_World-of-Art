tool
class_name BreakableTilesManager
extends Node2D

export(NodePath) var tilemapPath 
onready var tilemap : TileMap

func _ready():
	
	if not get_node_or_null(tilemapPath) is TileMap:
		tilemap = null
		tilemapPath = null
	else:
		tilemap = get_node_or_null(tilemapPath)
		

