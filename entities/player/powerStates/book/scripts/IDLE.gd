extends State

func process_state():
	if not parent.onFloor():
		return "FLY"
	
	if not parent.moving:
		return null
		
	elif Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) and not parent.cinematic:
		return "WALK"
	
	elif parent.canJump and not parent.cinematic and parent.jumpBuffer:
		return "JUMP"
	
	elif parent.motion.y != 0 and parent.onSlope():
		return "FLY"

	return null
	
func process_physics(_delta):
	parent.idleBase()
	parent.playback.travel("IDLE")
