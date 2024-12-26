class_name CameraLimitsArea extends Area2D

export var limitsMin := Vector2(-10000000, -10000000)
export var limitsMax := Vector2(10000000, 10000000)

func _init():
	collision_layer = 0
	collision_mask = 256
	
	var _1 := connect("area_entered", self, "entered")
	
func entered(area):
	
	if area.get_parent().is_in_group("player"):
		Global.world.setCameraLimits(limitsMin + global_position, limitsMax + global_position)
