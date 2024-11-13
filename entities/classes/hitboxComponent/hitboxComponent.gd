class_name HitboxComponent extends Area2D

signal HitboxDamaged(damage, area)

func hit(damage, area):
	emit_signal("HitboxDamaged", damage, area)
