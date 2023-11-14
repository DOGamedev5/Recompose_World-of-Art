extends State

func enter():
	parent.playback.travel("JUMP")

func process_state():
	if parent.motion.y > 0:
		return "FALL"

	elif parent.floorDetect.is_colliding():
		if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
			if Input.is_action_pressed("run"):
				return "TOP_SPEED"
			
			return "RUN"
		
		return "IDLE"
	
	return null

func process_physics(_delta):
	parent.jumpBase()
	var maxSpeed = parent.MAXSPEED
	if parent.running:
		maxSpeed = parent.runningVelocity
	parent.motion.x = parent.moveBase("X", parent.motion.x, maxSpeed)
