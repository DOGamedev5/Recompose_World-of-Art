extends State

func enter(laststate):
	parent.setParticle(0, false)
	parent.setParticle(1, false)
	
	parent.snapDesatived = true
	if laststate == "ROLL":
		parent.isRolling = true

func process_state():
	if parent.onWallRayCast[1].is_colliding() and abs(parent.motion.x) > 250:
		return "WALL"
	
	if parent.motion.y > 0:
		return "FALL"

	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
			
		if Input.is_action_pressed("run"): return "TOP_SPEED"
			
		return "RUN"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttack:
		return "ATTACK"
	
	elif (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and parent.canLadder:
		return "LADDER"
	
	return null

func process_physics(_delta):
	parent.stoppedRunning()
	
	if parent.isRolling:
		parent.motion.x = sign(parent.motion.x) * parent.MAXSPEED
		parent.playback.travel("ROLL")
	
	elif not parent.counched or parent.running:
		var maxSpeed : float
		if parent.running:
			parent.playback.travel("TOP_SPEED")
			maxSpeed = parent.runningVelocity
		else:
			parent.playback.travel("NORMAL")
			parent.normalPlayback.travel("JUMP")
			maxSpeed = parent.MAXSPEED
		
		parent.moveBase("X", parent.motion.x, maxSpeed)

		parent.jumpBase()
	
	else:
		parent.playback.travel("COUNCH")
		parent.counchPlayback.travel("COUNCHJUMP")
		
		parent.moveBase("X", parent.motion.x, 240)
		
		parent.jumpBase(-535)

func exit():
	parent.snapDesatived = false
	parent.isRolling = false

