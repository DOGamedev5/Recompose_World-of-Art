extends Area2D

export var tilemapPath : NodePath
onready var tilemap : TileMap = get_node_or_null(tilemapPath) as TileMap

func _init():
	monitoring = false
	set_collision_mask_bit(0, false)
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	add_to_group("digable")

