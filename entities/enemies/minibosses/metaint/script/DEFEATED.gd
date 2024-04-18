extends State

var direction

func enter(_lastState):
	parent.playback.travel("DEFEATED")
	
	direction = -(1 - 2*int(parent.fliped))
	parent.flipLock = true
	parent.motion.y = -800

func process_state():
	if parent.is_on_floor() and parent.motion.y >= 0:
		return "DEFEAT"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.moveBase(direction, parent.motion.x)
	
	
