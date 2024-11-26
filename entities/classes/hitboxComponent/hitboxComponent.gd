class_name HitboxComponent extends Area2D

signal HitboxDamaged(damage)

var active := false

func _ready():
	active = true

func hit(damage : DamageAttack):
	if not active: return
	emit_signal("HitboxDamaged", damage)
