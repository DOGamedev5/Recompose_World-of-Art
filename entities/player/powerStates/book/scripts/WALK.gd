extends State

func process_state():
	if not parent.onFloor():
		return "FLY"
		
	if not parent.motion.x and Input.get_axis("ui_left", "ui_right") == 0 and not parent.cinematic:
		return "IDLE"
	
	elif parent.canJump and not parent.cinematic and parent.jumpBuffer:
		return "JUMP"

	return null

func process_physics(_delta):

	parent.moveBase("X", parent.motion.x)
	parent.playback.travel("WALK")
