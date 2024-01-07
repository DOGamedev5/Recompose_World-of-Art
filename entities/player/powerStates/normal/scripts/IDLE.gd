extends State


func enter(_lastState):
	if parent.counched:
		parent.playback.travel("COUNCH")
		parent.setCollision(2)
	else:
		parent.playback.travel("IDLE")
		parent.setCollision(0)
	parent.running = false
	

func process_state():
	if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
		if parent.onWall():
			return "WALL"
		
		if Input.is_action_pressed("run"):
			return "TOP_SPEED"
		
		return "RUN"

	elif parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	elif not parent.onFloor().has(true):
		return "FALL"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttackTimer == 0 and parent.couldUncounch():
		return "ATTACK"

	return null
	
func process_physics(_delta):
	parent.idleBase()
	
	if parent.counched:
		parent.playback.travel("COUNCH")
		parent.setCollision(2)
	else:
		parent.playback.travel("IDLE")
		parent.setCollision(0)
