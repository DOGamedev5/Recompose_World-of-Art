extends Area2D

func _ready():
	var _1 = connect("area_entered", self, "_on_coin_area_entered")
	randomize()
	var typeCoin = randi() % 3
	$"%Coins".region_rect.position.y = typeCoin * 8

func _on_coin_area_entered(area):
	if not area.is_in_group("player"): return
	Global.currentRoom.addToRoomData(name, "collectedCoins")
	
	queue_free()
