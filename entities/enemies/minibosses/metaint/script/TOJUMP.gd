extends State

onready var timer = $cooldown

func enter(_lastState):
	parent.flipLock = true
	parent.playback.travel("TOJUMP")
	timer.start()

func process_state():
	if timer.is_stopped() and parent.active:
		return "JUMP"
	
	return null

	
