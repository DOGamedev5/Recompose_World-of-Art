extends State

func enter(_ls):
	parent.isDigging = false
#
#	parent.setParticle(0, false)

func process_state():
	
	if parent.canJump and parent.jumpBuffer:
		return "JUMP"
	
	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
		
		return "WALK"
	
	elif Global.handInput("attack", parent.OwnerID) and parent.canDig:
		return "DRIVE"
	
	return null

func process_physics(_delta):
	if not parent.moving: return
	
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
	
	parent.playback.travel("FALL")
	
	var input := Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)
	parent.motion.x = input * parent.MAXSPEED



