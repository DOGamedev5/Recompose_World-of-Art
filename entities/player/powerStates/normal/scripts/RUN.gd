extends State

func enter(_lastState):
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
		Global.world.add_child(smoke)
		smoke.global_position = parent.global_position - Vector2(0, 32)
		parent.topSpeedPlayback.travel("RUN")

func process_state():
	if parent.onWall():
		return "WALL"
	
	if (parent.onSlope() or abs(parent.motion.x) > 900) and Input.is_action_just_pressed("ui_down"):
		return "SUPERROLL"
			
	if parent.motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0:
		return "IDLE"
		
	elif parent.canJump and parent.jumpBuffer and parent.couldUncounch():
		return "JUMP"
	
	elif not parent.onFloor():
		return "FALL"
	
	elif not Input.is_action_pressed("run"):
		return "WALK"
	
	return null

func process_physics(_delta):
	
	parent.moveBase("X", parent.motion.x, parent.runningVelocity)
	parent.detectRunning()
	
	if sign(parent.motion.x) != sign(Input.get_axis("ui_left", "ui_right")) and parent.motion.x != 0:
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
