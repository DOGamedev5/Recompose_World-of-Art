class_name AttackComponent extends Area2D

export var damage := 0 setget setDamage
export var hasOwnerID := false
export(String, "player", "enemy", "any") var group := "player"

signal attacked

func _ready():
	connect("area_entered", self, "_on_attackComponent_area_entered")
	add_to_group(group)

func setDamage(newDamage):
	damage = newDamage
	monitoring = damage != 0 

func _on_attackComponent_area_entered(area):
	if (not (area is HitboxComponent)) or damage <= 0: return
	
	var attack := DamageAttack.new()
	attack.damage = damage
	attack.direction = (area.get_parent().global_position - get_parent().global_position).normalized()
	attack.objectGroup = get_groups()
	if hasOwnerID: attack.objectId = get_parent().OwnerID
	
	emit_signal("attacked")
	area.hit(attack)
