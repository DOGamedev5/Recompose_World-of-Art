extends State



func enter(_lastState):
	parent.setParticle(0, false)
	parent.setParticle(1, true)
	parent.playback.travel("TOP_SPEED")
	
	if abs(parent.motion.x) > parent.MAXSPEED:
		parent.running = true
	



func process_state():
	if parent.onWall():
		return "WALL"
			
	if parent.motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0:
		return "IDLE"
		
	elif parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	elif not parent.onFloor():
		return "FALL"
	
	elif not Input.is_action_pressed("run") :
		return "RUN"
	
	return null

func process_physics(_delta):
	
	parent.moveBase("X", parent.motion.x, parent.runningVelocity)
	parent.detectRunning()
	
	if sign(parent.motion.x) != sign(Input.get_axis("ui_left", "ui_right")) and parent.motion.x != 0:
		parent.playback.travel("STOPPING")
	else:
		parent.playback.travel("TOP_SPEED")

func exit():
	parent.setParticle(1, false)
	if not parent.running or abs(parent.motion.x) <= parent.MAXSPEED:
		parent.attackComponents[1].monitoring = false
		
	parent.setCollision(0)
