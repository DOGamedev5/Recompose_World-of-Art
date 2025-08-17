extends Area2D



func _on_keyCollect_area_entered(area):
	if not area.is_in_group("player"): return
	
	var smoke = load("res://objects/dustBlow/dustBlow.tscn").instance()
	
	smoke.amount = 4
	
	Global.world.add_child(smoke)
	smoke.global_position = global_position
	
	get_parent().collect(self)

