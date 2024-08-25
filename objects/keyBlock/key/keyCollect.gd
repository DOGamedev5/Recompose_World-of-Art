extends Area2D



func _on_keyCollect_area_entered(area):
	if not area.is_in_group("player"): return
	
	get_parent().collect(self)

