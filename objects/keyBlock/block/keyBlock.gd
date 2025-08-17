extends Node2D



func destroy():
	var smoke = load("res://objects/dustBlow/dustBlow.tscn").instance()
	
	Global.world.add_child(smoke)
	smoke.global_position = global_position
	queue_free()
