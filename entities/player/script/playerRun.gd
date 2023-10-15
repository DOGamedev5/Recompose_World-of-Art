extends "res://entities/player/script/player.gd"

func physics_process(delta):
	
	accelerate()
			
	if can_jump and Input.is_action_pressed("ui_jump"):
		currentState = "jump"

	if not is_on_floor():
		currentState = "jump"
	
	if motion.x == 0 and not Input.get_axis("ui_left", "ui_right"):
		currentState = "idle"
	
