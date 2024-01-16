extends State


func enter(_lastState):
	parent.running = false
	

func process_state():
	if parent.onSlope()[0] and Input.is_action_just_pressed("ui_down"):
		return "ROLL"
		
	elif Input.get_axis("ui_left", "ui_right") != 0:
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
		parent.setCollision(1)
	else:
		parent.playback.travel("IDLE")
		parent.setCollision(0)
