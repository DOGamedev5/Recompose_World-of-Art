extends State


func process_state():
	if parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
		
		return "WALK"
	
	return null
