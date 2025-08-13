tool
class_name BreakableTiles
extends HitboxComponent

onready var tilePos : Vector2
	
func _ready():
	connect("HitboxDamaged", self, "breakTile")
	
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(8, true)

func breakTile(damage : DamageAttack):
	
	tilePos = get_parent().tilemap.world_to_map(position/2)

	if "player" in damage.objectGroup and damage.damage > 0:
		get_parent().tilemap.set_cellv(tilePos, -1)
		
		queue_free()
	
