extends State

onready var timer = $cooldown

func enter(_lastState):
	parent.playback.travel("TORUN")
	timer.start()

func process_state():
	if timer.is_stopped() and parent.active:
		return "RUN"
	
	return null


