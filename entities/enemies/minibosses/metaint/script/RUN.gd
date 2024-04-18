extends State

onready var timer = $Timer
onready var attack = $"../../runAttack"

var direction := -1

func enter(_lastState):
	parent.playback.travel("RUN")
	attack.monitoring = true
	direction = 1 - 2*int(parent.fliped)
	timer.start()

func process_state():
	if timer.is_stopped() or parent.is_on_wall():
		return "IDLE"
	
	return null

func exit():
	attack.monitoring = false
	parent.flipLock = false

func process_physics(_delta):
	parent.motion.x = parent.moveBase(direction, parent.motion.x, 1000, 100)

