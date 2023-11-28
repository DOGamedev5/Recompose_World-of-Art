extends State

func enter(_lastState):
	parent.playback.travel("TOP_SPEED")
	parent.running = true
	
	if abs(parent.motion.x) > parent.MAXSPEED:
		if abs(parent.motion.x) <+ 550:
			parent.attackDamage.setDamage(1)
		else:
			parent.attackDamage.setDamage(2)
	
	else:
		parent.attackDamage.setDamage(0)

func process_state():
	if parent.onWall():
		return "WALL"
			
	if parent.motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0 :
		return "IDLE"
		
	elif parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif not parent.floorDetect.is_colliding():
		return "FALL"
	
	elif not Input.is_action_pressed("run") :
		return "RUN"
	
	return null

func process_physics(_delta):
	if abs(parent.motion.x) > parent.MAXSPEED:
		if abs(parent.motion.x) <+ 550:
			parent.attackDamage.setDamage(1)
		else:
			parent.attackDamage.setDamage(2)
	
	else:
		parent.attackDamage.setDamage(0)
	
	parent.motion.x = parent.moveBase("X", parent.motion.x, parent.runningVelocity)
	if abs(parent.motion.x) > 450:
		parent.running = true
	
	if sign(parent.motion.x) != sign(Input.get_axis("ui_left", "ui_right")) and parent.motion.x != 0:
		parent.playback.travel("STOPPING")
	else:
		parent.playback.travel("TOP_SPEED")

func exit():
	if not parent.running or abs(parent.motion.x) <= parent.MAXSPEED:
		parent.attackDamage.setDamage(0)
