class_name AttackComponent extends Area2D

export var damage := 0 setget setDamage

func _ready():
	connect("area_entered", self, "_on_attackComponent_area_entered")

func setDamage(newDamage):
	damage = newDamage
	monitoring = damage != 0 

func _on_attackComponent_area_entered(area):
	if not (area is HitboxComponent):
		return
	
	area.hit(damage, self)
