extends State

func enter(_laststate):
	parent.setParticle(0, false)
	parent.setParticle(1, false)

func process_state():
	if not parent.moving:
		return null
		
	if parent.onSlope() and Global.handInput("ui_down", parent.OwnerID):
		return "ROLL"
		
	elif Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) != 0 and not parent.cinematic:
		if Input.is_action_pressed("run") and parent.couldUncounch(true):
			return "RUN"
		
		return "WALK"

	elif parent.canJump and not parent.cinematic and parent.jumpBuffer and parent.couldUncounch(true):
		return "JUMP"
	
	elif not parent.onFloor():
		return "FALL"
	
	elif Global.handInput("attack", parent.OwnerID) and parent.canAttack and parent.couldUncounch(true):
		return "ATTACK"
	
	if Global.handInputAxis("ui_up", "ui_down", parent.OwnerID) and parent.canLadder:
		return "LADDER"

	return null
	
func process_physics(_delta):
	parent.idleBase()
	
	if parent.counched:
		parent.playback.travel("COUNCH")
	else:
		parent.playback.travel("NORMAL")
	
	if not parent.is_on_floor():
		if parent.counched:
			parent.counchPlayback.travel("COUNCHFALL")
		else:
			parent.normalPlayback.travel("FALL")
		
	else:
		if parent.counched:
			parent.counchPlayback.travel("COUNCH")
		else:
			parent.normalPlayback.travel("IDLE")
