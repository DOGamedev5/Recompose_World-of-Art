extends State

onready var timer := $Timer

func enter(_ls):
	parent.motion.y = parent.JUMPFORCE
	timer.start()

func process_state():
	if timer.is_stopped():
		return "EXPLODE"



