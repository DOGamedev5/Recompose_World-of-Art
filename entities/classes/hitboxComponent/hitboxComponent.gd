class_name HitboxComponent extends Area2D

signal HitboxDamaged(damage)

func hit(damage : DamageAttack):
	emit_signal("HitboxDamaged", damage)
