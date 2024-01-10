class_name HitboxComponent extends Area2D

signal HitboxDamaged(damage, area)

func _ready():
	connect("area_entered", self, "_areaEntered")
	
func _areaEntered(area):
	var damage := 0
	
	emit_signal("HitboxDamaged", damage, area)
	
