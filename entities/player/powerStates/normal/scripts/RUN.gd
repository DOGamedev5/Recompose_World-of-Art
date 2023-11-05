extends State


func enter():
	parent.playback.travel("RUN")

func process_state():
	if parent.onWall.is_colliding():
		return "WALL"
			
	if parent.motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0 :
		return "IDLE"
		
	elif parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif not parent.floorDetect.is_colliding():
		return "FALL"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.moveBase(Input.get_axis("ui_left", "ui_right"), parent.motion.x)
