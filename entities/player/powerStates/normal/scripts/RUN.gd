extends State

func enter(_lastState):
	
	if abs(parent.motion.x) < 250:
		parent.motion.x = 250 * Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)
		
	parent.setParticle(0, false)
	parent.setParticle(1, true)
	parent.playback.travel("RUN")
	parent.setCollision(0)
	
	if abs(parent.motion.x) < 120:
		parent.motion.x = 120 * sign(parent.motion.x)
	
	if abs(parent.motion.x) > parent.MAXSPEED and not parent.running:
		parent.running = true
		var smoke : CPUParticles2D = load("res://objects/dustBlow/dustBlow.tscn").instance()
		smoke.amount = 12
		smoke.lifetime = 0.6
		smoke.preprocess = 0.2
		parent.get_parent().add_child(smoke)
		smoke.global_position = parent.global_position - Vector2(0, 32)
		parent.topSpeedPlayback.travel("RUN")

func process_state():
	if parent.onWall():
		return "WALL"
	
	if (parent.onSlope() or abs(parent.motion.x) > 900) and Global.handInput("ui_down", parent.OwnerID):
		return "SUPERROLL"
			
	if parent.motion.x == 0 and Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) == 0:
		return "IDLE"
		
	elif parent.canJump and parent.jumpBuffer and parent.couldUncounch():
		return "JUMP"
	
	elif not parent.onFloor():
		return "FALL"
	
	elif not Global.handInput("run", true):
		return "WALK"
	
	elif Global.handInputAxis("ui_up", "ui_down", parent.OwnerID) and parent.canLadder:
		return "LADDER"
	
	return null

func process_physics(_delta):
	
	parent.moveBase("X", parent.motion.x, parent.runningVelocity)
	parent.detectRunning()
	
	if sign(parent.motion.x) != sign(Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)) and parent.motion.x != 0:
		parent.playback.travel("NORMAL")
		parent.normalPlayback.travel("STOPPING")
	else:
		parent.playback.travel("RUN")
		if parent.running:
			parent.topSpeedPlayback.travel("RUN")
		

func exit():
	parent.setParticle(1, false)
	if not parent.running or abs(parent.motion.x) <= parent.MAXSPEED:
		parent.attackComponents[1].monitoring = false
		
	parent.setCollision(0)
