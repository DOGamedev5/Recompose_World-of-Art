extends State

var lastState

func enter(laststate):
	parent.setParticle(0, false)
	parent.setParticle(1, false)
	var smoke = load("res://objects/dustBlow/dustBlow.tscn").instance()
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
			
		if Input.is_action_pressed("run"): return "RUN"
			
		return "WALK"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttack:
		return "ATTACK"
	
	elif (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and parent.canLadder:
		return "LADDER"
	
	return null

func process_physics(_delta):
	parent.stoppedRunning()
	
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
	
	if parent.isRolling:
		parent.motion.x = sign(parent.motion.x) * parent.MAXSPEED
		parent.playback.travel("NORMAL")
		parent.normalPlayback.travel("ROLL")
	
	elif not parent.counched or parent.running:
		var maxSpeed : float
		if parent.running:
			parent.playback.travel("RUN")
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

