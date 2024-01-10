extends State


func enter(_lastState):
	if not parent.counched or parent.running:
		if parent.running:
			parent.playback.travel("TOP_SPEED")
		else:
			parent.playback.travel("FALL")
		
		parent.setCollision(1)
	else:
		parent.playback.travel("COUNCHFALL")
		parent.setCollision(2)

func process_state():
	if parent.onWall() and abs(parent.motion.x) > 300:
		return "WALL"
	
	if parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	elif parent.onFloor().has(true):
		if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
			if Input.is_action_pressed("run") and parent.running:
				return "TOP_SPEED"
			
			return "RUN"
		
		return "IDLE"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttackTimer == 0:
		return "ATTACK"
	
	return null

func process_physics(_delta):
	if parent.running and abs(parent.motion.x) <= parent.MAXSPEED:
		parent.running = false
	
	if not parent.counched or parent.running:
		var maxSpeed : float
		if parent.running:
			parent.playback.travel("TOP_SPEED")
			maxSpeed = parent.runningVelocity
		else:
			parent.playback.travel("FALL")
			maxSpeed = parent.MAXSPEED
		
		parent.motion.x = parent.moveBase("X", parent.motion.x, maxSpeed)
		parent.setCollision(1)
	else:
		parent.playback.travel("COUNCHFALL")
		parent.motion.x = parent.moveBase("X", parent.motion.x, 180)
		parent.setCollision(2)
	
func exit():
	parent.setCollision(0)
