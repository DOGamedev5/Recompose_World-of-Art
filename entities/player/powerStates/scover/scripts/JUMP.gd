extends State


func enter(_ls):
	parent.snapDesatived = true
	parent.isDigging = false

func process_state():
	if parent.motion.y > 0:
		return "FALL"

	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
			
		return "WALK"
	
	elif Global.handInput("attack", parent.OwnerID) and parent.canDig:
		return "DRIVE"
	
	return null

func process_physics(_delta):
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
		
	parent.playback.travel("JUMP")
	var input := Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)
	
	parent.motion.x = input * parent.MAXSPEED
	parent.jumpBase()
	

func exit():
	parent.snapDesatived = false
