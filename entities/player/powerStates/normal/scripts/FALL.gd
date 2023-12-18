extends State


func enter(_lastState):
	parent.setCollision(1)
	if parent.running:
		parent.playback.travel("TOP_SPEED")
	else:
		parent.playback.travel("FALL")
	
	

func process_state():
	if parent.onWall() and abs(parent.motion.x) > 200:
		return "WALL"
	
	if parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif parent.onFloor().has(true):
		if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
			if Input.is_action_pressed("run") and parent.running:
				return "TOP_SPEED"
			
			return "RUN"
		
		return "IDLE"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttackTimer == 0:
		return "ATTACK"
	
	return null

func process_physics(_delta):
	if parent.running and abs(parent.motion.x) <= parent.MAXSPEED:
		parent.running = false
	
	if parent.running:
		parent.playback.travel("TOP_SPEED")
	else:
		parent.playback.travel("FALL")
	
	
	var maxSpeed = parent.MAXSPEED
	if parent.running:
		maxSpeed = parent.runningVelocity
	parent.motion.x = parent.moveBase("X", parent.motion.x, maxSpeed)

func exit():
	parent.setCollision(0)
