extends State

var direction : int

func itsDamaged(dir):
	parent.stateMachine.changeState("DAMAGED")
	direction = -dir
	parent.snapDesatived = true
	parent.playback.travel("DAMAGED")
	parent.motion.y = -600
	parent.motion.x = 600 * direction
	parent.shield()


func process_state():
	if parent.motion.x == 0:
		if not parent.onFloor():
			return "FALL"
		
		return "IDLE"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.desaccelerate(parent.motion.x, 0)

func exit():
	parent.snapDesatived = false

