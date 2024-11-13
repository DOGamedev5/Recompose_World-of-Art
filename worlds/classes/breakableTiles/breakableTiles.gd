tool
class_name BreakableTiles
extends HitboxComponent

onready var tilePos : Vector2
	
func _ready():
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(8, true)

func breakTile(damage, area : Area2D):
	tilePos = get_parent().tilemap.world_to_map(global_position/2)
	if area.get_parent().is_in_group("player") and damage > 0:
		get_parent().tilemap.set_cellv(tilePos, -1)

		queue_free()
	
