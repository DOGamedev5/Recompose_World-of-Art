extends State

func enter():
	parent.playback.travel("WALL")
	parent.running = false

func process_state():
	if Input.get_axis("ui_left", "ui_right") == 0:
		return "IDLE"
	
	elif parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif not parent.floorDetect.is_colliding():
		return "FALL"
	
	elif not parent.onWall.is_colliding():
		return "RUN"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.moveBase("X", parent.motion.x, 350)
