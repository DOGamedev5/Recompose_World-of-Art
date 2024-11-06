tool
class_name BreakableTiles
extends HitboxComponent

onready var tilePos : Vector2

func _init():
	for child in get_children():
		if child.name == "shape" or child.name == "enable":
			child.queue_free()
	
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.extents = Vector2(32, 18)
	collision.shape = shape
	collision.name = "shape"
	
	add_child(collision)
	var enable := VisibilityEnabler2D.new()
	enable.process_parent = true
	enable.physics_process_parent = true
	enable.rect.position = Vector2(-9, -9)
	enable.rect.size = Vector2(18, 18)
	enable.name = "enable"
	add_child(enable)
	
func _ready():
	var _1 = connect("HitboxDamaged", self, "breakTile")
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(8, true)

func breakTile(damage, area : Area2D):
	tilePos = get_parent().tilemap.world_to_map(global_position/2)
	if area.get_parent().is_in_group("player") and damage > 0:
		get_parent().tilemap.set_cellv(tilePos, -1)

		queue_free()
	
