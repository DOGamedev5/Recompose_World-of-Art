extends Node2D
class_name Statue

export(NodePath) var hitboxPath
export(int) var timer := 3*60
onready var hitbox : HitboxComponent = get_node(hitboxPath)

func _ready():
	hitbox.set_collision_layer(256)
	hitbox.set_collision_mask(0)
	
	var _1 = hitbox.connect("HitboxDamaged", self, "destroy")

func destroy(attack : DamageAttack):
	if "player" in attack.objectGroup:
		var smoke = load("res://objects/dustBlow/dustBlow.tscn")
		var smokes := []
		for _i in range(5):
			var newSmoke = smoke.instance()
			newSmoke.amount = 4
			newSmoke.lifetime = 1
			newSmoke.preprocess = 0.3
			smokes.append(newSmoke)
		
		smokes[0].global_position = to_global(Vector2(32, -32))
		smokes[1].global_position = to_global(Vector2(16, -64))
		smokes[2].global_position = to_global(Vector2(-16, -24))
		smokes[3].global_position = to_global(Vector2(-8, -72))
		smokes[4].global_position = to_global(Vector2(16, -104))
		
		for smk in smokes:
			Global.world.add_child(smk)
		

		Global.world.setupTimer(timer)
		
		queue_free()
