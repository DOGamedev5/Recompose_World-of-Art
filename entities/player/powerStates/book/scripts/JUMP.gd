extends State

func enter(_laststate):
	parent.snapDesatived = true

func process_state():
	if parent.motion.y > 0:
		return "FLY"

	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
			
		return "WALK"
	
	if Global.handInput("attack", false, parent.OwnerID):
		return "FLY"
	
	return null

func process_physics(_delta):
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
		
	parent.moveBase("X", parent.motion.x)
	parent.jumpBase()
	parent.playback.travel("JUMP")

func exit():
	parent.snapDesatived = false
