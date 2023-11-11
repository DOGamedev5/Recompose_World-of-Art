extends State


func enter():
	parent.playback.travel("IDLE")
	parent.running = false
	

func process_state():
	if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
		if parent.onWall.is_colliding():
			return "WALL"
		
		if Input.is_action_pressed("run"):
			return "TOP_SPEED"
		
		return "RUN"

	elif parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif not parent.floorDetect.is_colliding():
		return "FALL"
	
	elif Input.is_action_just_pressed("ui_accept"):
		
		parent.changePowerup("Fly")

	return null
	
func process_physics(_delta):
	parent.idleBase()
	
