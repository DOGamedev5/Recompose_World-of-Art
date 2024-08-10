extends State


func process_state():
	if Input.is_action_just_pressed("ui_jump") or parent.is_on_wall():
		return "FALL"
	
	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
		
		return "WALK"
	
	return null

func process_physics(_delta):
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
		
	parent.moveBase("X", parent.motion.x)
	parent.playback.travel("FLY")
