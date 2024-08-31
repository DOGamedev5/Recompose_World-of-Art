extends Area2D

func _ready():
	randomize()
	var typeCoin = randi() % 3
	$"%Coins".region_rect.position.y = typeCoin * 8

func _on_coin_area_entered(area):
	if not area.is_in_group("player"): return
	
	queue_free()
