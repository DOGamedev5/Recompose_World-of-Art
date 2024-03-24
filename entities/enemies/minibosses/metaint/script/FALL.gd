extends State

onready var attack := $"../../jumpAttack"

func enter(_lastState):
	parent.playback.travel("FALL")

func exit():
	
	attack.monitoring = true
	
	yield(get_tree().create_timer(0.25), "timeout")
	
	attack.monitoring = false

func process_state():
	if parent.onFloor():
		return "IDLE"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.moveBase(1 - 2*int(parent.fliped), parent.motion.x, 550, 4)
