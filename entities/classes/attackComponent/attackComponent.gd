class_name AttackComponent extends Area2D

export var damage := 0
		
var ray
var collision

func _ready():
	var _1 = connect("area_entered", self, "_enterHitbox")

func _enterHitbox(area):
	pass
#	if area is BreakableTiles:
#		area.breakTile(damage, self)
#
#	if area is HitboxComponent:
#		area.emit_signal("HitboxDamaged", damage, self)

func setDamage(newDamage):
	damage = newDamage
	monitoring = damage != 0 
