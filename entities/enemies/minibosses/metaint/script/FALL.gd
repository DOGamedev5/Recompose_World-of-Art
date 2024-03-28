extends State

onready var attack := $"../../jumpAttack"

func enter(_lastState):
	parent.playback.travel("FALL")

func exit():
	parent.flipLock = false

func process_state():
	if parent.onFloor():
		return "IDLE"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.moveBase(1 - 2*int(parent.fliped), parent.motion.x, 550, 4)
