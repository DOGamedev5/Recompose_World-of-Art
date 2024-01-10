extends State

var direction : int

func itsDamaged(direction):
	parent.stateMachine.changeState("DAMAGED")
	self.direction = -direction

func enter(_lastState):
	parent.playback.travel("DAMAGED")
	parent.motion.y = -300
	parent.motion.x = 300 * direction
	parent.shield()

func process_state():
	if parent.motion.x == 0:
		return "IDLE"
	
	return null

func process_physics(delta):
	parent.motion.x = parent.moveBase("X", parent.motion.x, 0)
