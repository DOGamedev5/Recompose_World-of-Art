extends State

var direction := -1

func enter(_lastState):
	if parent.position.x < 320:
		direction = 1
	elif parent.position.x > 1216:
		direction = -1
	
func exit():
	pass

func process_state():
	if parent.position.x <= 1216 and parent.position.x >= 320:
		return "IDLE"
	
	return null

func process_physics(_delta):
	
	parent.motion.x = parent.moveBase(direction, parent.motion.x)
	
	parent.playback.travel("IDLE")
