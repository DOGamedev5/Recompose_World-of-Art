class_name HitboxComponent extends Area2D

signal HitboxDamaged(damage, area)

func _ready():
	var _1 = connect("area_entered", self, "_areaEntered")

func _areaEntered(area):
	var damage := 0
	
	if area is AttackComponent:
		damage = area.damage
	
	emit_signal("HitboxDamaged", damage, area)

