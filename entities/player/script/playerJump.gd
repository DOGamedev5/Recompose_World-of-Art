extends "res://entities/player/script/player.gd"


func physics_process(player, delta):
	accelerate()
	jump()
	
	if is_on_floor():
		if Input.get_axis("ui_left", "ui_right"):
			player.currentState = "idle"
		else:
			currentState = "run"

