extends State

func enter(laststate):
	
	parent.setParticle(0, false)
	
	if laststate == "ROLL":
		parent.isRolling = true

func process_state():
	if parent.onWallRayCast[1].is_colliding() and abs(parent.motion.x) > 250:
		return "WALL"
	
	if parent.canJump and parent.jumpBuffer and parent.couldUncounch():
		return "JUMP"
	
	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
		
		if parent.isRolling: return "ROLL"
		
		if Global.handInput("run", true): return "RUN"
		
		return "WALK"
	
	elif Global.handInput("attack") and parent.canAttack:
		return "ATTACK"
	
	elif Global.handInputAxis("ui_up", "ui_down") and parent.canLadder:
		return "LADDER"
	
	return null

func process_physics(_delta):
	if not parent.moving: return
	var maxSpeed : float
	
	parent.stoppedRunning()
	
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
	
	if parent.isRolling:
		parent.motion.x = sign(parent.motion.x) * parent.MAXSPEED
		parent.playback.travel("NORMAL")
		parent.normalPlayback.travel("ROLL")
	
	elif not parent.counched or parent.running:
		if parent.running:
			parent.playback.travel("RUN")
			maxSpeed = parent.runningVelocity
			
		else:
			parent.playback.travel("NORMAL")
			parent.normalPlayback.travel("FALL")
			maxSpeed = parent.MAXSPEED
		
	else:
		parent.playback.travel("COUNCH")
		parent.counchPlayback.travel("COUNCHFALL")
		
		maxSpeed = 180
		
	
	parent.moveBase("X", parent.motion.x, maxSpeed)


