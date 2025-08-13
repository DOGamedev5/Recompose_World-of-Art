extends Area2D

export var tilemapPath : NodePath
onready var tilemap : TileMap = get_node_or_null(tilemapPath) as TileMap

func _init():
	collision_layer = 0
	collision_mask = 256
	
	tilemap.collision_layer = 0
	tilemap.collision_mask = 0
	
	connect("area_entered", self, "_playerEntered")
	
func _playerEntered(area : Area2D):
	if area.get_parent().is_in_group("player"):
		if not Network.is_owned(area.get_parent().OwnerID): return
		
		pass
	
	
