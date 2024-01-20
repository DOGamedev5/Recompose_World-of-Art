extends State

func enter(laststate):
	parent.runningParticle = false
	if laststate == "ROLL":
		parent.isRolling = true

func process_state():
	if parent.onWall() and abs(parent.motion.x) > 300:
		return "WALL"
	
	if parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	elif parent.onFloor().has(true):
		if parent.motion.x == 0: return "IDLE"
		
		if parent.isRolling: return "ROLL"
		
		if Input.is_action_pressed("run"): return "TOP_SPEED"
		
		return "RUN"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttackTimer == 0:
		return "ATTACK"
	
	return null

func process_physics(_delta):
	var maxSpeed : float
	
	if parent.running and abs(parent.motion.x) + abs(parent.motion.y) <= parent.MAXSPEED:
		parent.running = false
	
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


