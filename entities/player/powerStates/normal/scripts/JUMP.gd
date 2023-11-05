extends State

#func enter():
#	parent.playback.travel("JUMP")

func process_state():
	if parent.motion.y > 0:
		return "FALL"

	elif parent.floorDetect.is_colliding():
		if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
			return "RUN"
			
		else:
			 return "IDLE"
	
	return null

func process_physics(_delta):
	parent.jumpBase()
	parent.motion.x = parent.moveBase(Input.get_axis("ui_left", "ui_right"), parent.motion.x)
