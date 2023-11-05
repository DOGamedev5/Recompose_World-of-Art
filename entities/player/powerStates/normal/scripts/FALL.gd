extends State

func process_state():
	if parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif parent.floorDetect.is_colliding():
		if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
			
			return "RUN"

		else:
			return "IDLE"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.moveBase(Input.get_axis("ui_left", "ui_right"), parent.motion.x)
		
