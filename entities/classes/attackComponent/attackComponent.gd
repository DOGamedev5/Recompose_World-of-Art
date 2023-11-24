class_name AttackComponent extends Area2D

export var damage := 0

func _ready():
	connect("area_entered", self, "_enterHitbox")
	

func _enterHitbox(area):
	if area is HitboxComponent:
		area.emit_signal("HitboxDamaged")
