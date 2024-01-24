extends State

func enter(laststate):
#	if not parent.counched:
#		parent.jumpBase()
#	else:
#		parent.jumpBase(-535)
	parent.snapDesatived = true
	if laststate == "ROLL":
		parent.isRolling = true

func process_state():
	if parent.onWall() and abs(parent.motion.x) > 200:
		return "WALL"
	
	if parent.motion.y > 0:
		return "FALL"

	elif parent.onFloor().has(true):
		if parent.motion.x == 0: return "IDLE"
			
		if Input.is_action_pressed("run"): return "TOP_SPEED"
			
		return "RUN"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttackTimer == 0:
		return "ATTACK"
	
	elif Input.is_action_just_pressed("ui_up") and parent.canLadder:
		return "LADDER"
	
	return null

func process_physics(_delta):
	
	if parent.running and abs(parent.motion.x) + abs(parent.motion.y) <= parent.MAXSPEED:
		parent.running = false
	
	if parent.isRolling:
		parent.motion.x = sign(parent.motion.x) * parent.MAXSPEED
		parent.playback.travel("ROLL")
	
	elif not parent.counched or parent.running:
		var maxSpeed : float
		if parent.running:
			parent.playback.travel("TOP_SPEED")
			maxSpeed = parent.runningVelocity
		else:
			parent.playback.travel("JUMP")
			maxSpeed = parent.MAXSPEED
		
		parent.moveBase("X", parent.motion.x, maxSpeed)

		parent.jumpBase()
	else:
		parent.playback.travel("COUNCHJUMP")
		parent.moveBase("X", parent.motion.x, 240)

		parent.jumpBase(-535)

func exit():

	parent.snapDesatived = false
	parent.isRolling = false

