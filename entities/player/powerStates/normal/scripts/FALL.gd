extends State

func enter(laststate):
	
	parent.setParticle(0, false)
	if laststate == "ROLL":
		parent.isRolling = true

func process_state():
	if parent.onWall() and abs(parent.motion.x) > 300:
		return "WALL"
	
	if parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
		
		if parent.isRolling: return "ROLL"
		
		if Input.is_action_pressed("run"): return "TOP_SPEED"
		
		return "RUN"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttack:
		return "ATTACK"
	
	elif (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and parent.canLadder:
		return "LADDER"
	
	return null

func process_physics(_delta):
	if not parent.moving: return
	var maxSpeed : float
	
	parent.stoppedRunning()
	
	if parent.isRolling:
		parent.motion.x = sign(parent.motion.x) * parent.MAXSPEED
		parent.playback.travel("ROLL")
	
	elif not parent.counched or parent.running:
		if parent.running:
			parent.playback.travel("TOP_SPEED")
			maxSpeed = parent.runningVelocity
		else:
			parent.playback.travel("FALL")
			maxSpeed = parent.MAXSPEED
		
	else:
		parent.playback.travel("COUNCHFALL")
		maxSpeed = 180
		
	
	parent.moveBase("X", parent.motion.x, maxSpeed)


