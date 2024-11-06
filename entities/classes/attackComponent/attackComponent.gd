class_name AttackComponent extends Area2D

export var damage := 0

func setDamage(newDamage):
	damage = newDamage
	monitorable = damage != 0 
