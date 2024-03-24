extends State

var direction := 1

func enter(_lastState):
	parent.playback.travel("JUMP")
	
	direction = 1 - 2*int(parent.fliped)
	parent.motion.y = -1200

func process_state():
	if parent.is_on_ceiling() or parent.motion.y > 0:
		return "FALL"
	return null

func process_physics(_delta):
	parent.motion.x = parent.moveBase(direction, parent.motion.x, 550, 24)
	
