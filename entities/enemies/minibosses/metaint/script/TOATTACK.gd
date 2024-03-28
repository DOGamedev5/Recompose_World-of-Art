extends State

onready var timer = $cooldown

func enter(_lastState):
	parent.flipLock = true
	parent.motion.x = 0
	parent.playback.travel("TOATTACK")
	timer.start()

func process_state():
	if timer.is_stopped() and parent.active:
		return "ATTACK"
	
	return null
