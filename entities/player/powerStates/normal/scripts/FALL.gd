extends State

func enter():
	parent.playback.travel("FALL")
	
	if parent.running and abs(parent.motion.x) <= 450:
		parent.running = false

func process_state():
	if parent.onWall.is_colliding() and abs(parent.motion.x) > 250:
		return "WALL"
	
	if parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif parent.floorDetect.is_colliding():
		if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
			if Input.is_action_pressed("run"):
				return "TOP_SPEED"
			
			return "RUN"
		
		return "IDLE"
	
	return null

func process_physics(_delta):
	var maxSpeed = parent.MAXSPEED
	if parent.running:
		maxSpeed = parent.runningVelocity
	parent.motion.x = parent.moveBase("X", parent.motion.x, maxSpeed)
		
