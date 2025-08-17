extends State

onready var timer = $Timer
var direction := -1

func enter(_lastState):
	parent.playback.travel("ATTACK")
	direction = 1 - 2*int(parent.fliped)
	timer.start()

func process_state():
	if timer.is_stopped() or parent.is_on_wall():
		return "IDLE"
	
	return null

func exit():

	parent.flipLock = false
