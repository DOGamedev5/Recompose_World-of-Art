extends State


func enter(_laststate):
	parent.setParticle(0, true)
	parent.setParticle(1, false)
	parent.running = false
	
	if abs(parent.motion.x) < 150:
		parent.motion.x = 150 * Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)

func process_state():
	if parent.motion.x == 0 and (Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) == 0 or not parent.moving) :
		return "IDLE"
		
	if (parent.onSlope() or abs(parent.motion.x) > 500) and Global.handInput("ui_down", parent.OwnerID):
		return "ROLL"
	
	if parent.onWall():
		return "WALL"
		
	elif parent.canJump and parent.jumpBuffer and parent.couldUncounch(true):
		return "JUMP"
	
	elif not parent.onFloor():
		return "FALL"
	
	elif Global.handInput("run", true, parent.OwnerID) and parent.couldUncounch(true):
		return "RUN"
	
	elif Global.handInput("attack", parent.OwnerID) and parent.canAttack and parent.couldUncounch(true):
		return "ATTACK"
	
	elif (Global.handInput("ui_up", parent.OwnerID) or Global.handInput("ui_down", parent.OwnerID)) and parent.canLadder:
		return "LADDER"

	
	return null

func process_physics(_delta):
	var input := Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)
	
	if parent.counched:
		parent.moveBase("X", parent.motion.x, 180)
		if Network.is_owned(parent.OwnerID): parent.playback.travel("COUNCH")
		if Network.is_owned(parent.OwnerID): parent.counchPlayback.travel("CRAWLING")
		parent.setParticle(0, false)
		
	elif parent.couldUncounch(true):
		parent.moveBase("X", parent.motion.x)
		parent.setParticle(0, true)
		
		if Network.is_owned(parent.OwnerID): parent.playback.travel("NORMAL")
		
		if sign(parent.motion.x) != sign(input) and parent.motion.x != 0:
			if Network.is_owned(parent.OwnerID): parent.normalPlayback.travel("STOPPING")
		elif input != 0:
			if Network.is_owned(parent.OwnerID): parent.normalPlayback.travel("WALK")
	
	parent.animation["parameters/NORMAL/NORMAL/WALK/TimeScale/scale"] = max(0.5, (abs(parent.motion.x) / parent.MAXSPEED) * 3)

func exit():
	parent.setParticle(0, false)

	
