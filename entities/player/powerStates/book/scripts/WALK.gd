extends State

func process_state():
	if not parent.onFloor():
		return "FLY"
		
	if not parent.motion.x and Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) == 0 and not parent.cinematic:
		return "IDLE"
	
	elif parent.canJump and not parent.cinematic and parent.jumpBuffer:
		return "JUMP"

	return null

func process_physics(_delta):

	parent.moveBase("X", parent.motion.x)
	parent.playback.travel("WALK")
