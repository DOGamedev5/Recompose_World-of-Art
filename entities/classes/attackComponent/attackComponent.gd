class_name AttackComponent extends Area2D

export var damage := 0
		
var ray
var collision

func setDamage(newDamage):
	damage = newDamage
	monitoring = damage != 0 
