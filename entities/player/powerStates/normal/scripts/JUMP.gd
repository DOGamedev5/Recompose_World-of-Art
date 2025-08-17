extends State

var lastState

func enter(laststate):
	parent.setParticle(0, false)
	parent.setParticle(1, false)
	var smoke = parent.effects[0].instance()
	smoke.amount = 6
	parent.get_parent().add_child(smoke)
	smoke.global_position = parent.global_position
	
	lastState = laststate
	
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
			
		if Global.handInput("run", true, parent.OwnerID): return "RUN"
			
		return "WALK"
	
	elif Global.handInput("attack", parent.OwnerID) and parent.canAttack:
		return "ATTACK"
	
#	elif (InputHandler.InputPressed("ui_up") or InputHandler.InputPressed("ui_down")) and parent.canLadder:
	elif Global.handInputAxis("ui_up", "ui_down", parent.OwnerID) and parent.canLadder:
		return "LADDER"
	
	return null

func process_physics(_delta):
	parent.stoppedRunning()
	
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
	
	if parent.isRolling:
		parent.motion.x = sign(parent.motion.x) * parent.MAXSPEED
		if Network.is_owned(parent.OwnerID): parent.playback.travel("NORMAL")
		if Network.is_owned(parent.OwnerID): parent.normalPlayback.travel("ROLL")
	
	elif not parent.counched or parent.running:
		var maxSpeed : float
		if parent.running:
			if Network.is_owned(parent.OwnerID): parent.playback.travel("RUN")
			maxSpeed = parent.runningVelocity
		else:
			if Network.is_owned(parent.OwnerID): parent.playback.travel("NORMAL")
			if Network.is_owned(parent.OwnerID): parent.normalPlayback.travel("JUMP")
			maxSpeed = parent.MAXSPEED
		
		parent.moveBase("X", parent.motion.x, maxSpeed)

		parent.jumpBase()
	
	else:
		if Network.is_owned(parent.OwnerID): parent.playback.travel("COUNCH")
		if Network.is_owned(parent.OwnerID): parent.counchPlayback.travel("COUNCHJUMP")
		
		parent.moveBase("X", parent.motion.x, 240)
		
		parent.jumpBase(-535)

func exit():
	parent.snapDesatived = false
	parent.isRolling = false

