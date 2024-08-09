extends State

func enter(_ls):
	parent.MAXFALL = 600

func process_state():
	if parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
			
		return "WALK"

func process_physics(_delta):
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
		
	parent.moveBase("X", parent.motion.x)
	parent.playback.travel("FALL")

func exit():
	parent.MAXFALL = 100
