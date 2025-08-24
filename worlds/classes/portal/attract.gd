extends Area2D

var enteredPlayers := []

func _on_attract_area_entered(area):
	if not area.is_in_group("player"): return
	var player := area.get_parent() as PlayerBase
	
	player.moving = false
	player.active = false
	player.snapDesatived = true
	enteredPlayers.append(player)
#	player.motion = player.global_position - global_position

func _process(delta):
	for p in enteredPlayers:
		if not is_instance_valid(p): 
			enteredPlayers.erase(p)
			continue

		p.global_position = lerp(p.global_position, global_position + Vector2(0, 32 * 0.7), delta*8)
		p.scale = lerp(p.scale, Vector2(0.7, 0.7), delta*3)
		p.modulate = lerp(p.modulate, Color(0.7, 0.6, 1, 0.1), delta*6)
