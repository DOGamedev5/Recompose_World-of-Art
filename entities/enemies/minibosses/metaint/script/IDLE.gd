extends State

onready var timer = $Timer

var chooseNextAttack = ["TOJUMP", "TORUN"]


func enter(_lastState):

	if parent.active:
		timer.wait_time = rand_range(0.6, 1.2)
		timer.start()

func exit():
	pass

func process_state():
	
	
	if timer.is_stopped() and parent.active:
		if parent.position.x < 224 or parent.position.x > 1312:
			return "WALK"
		
		chooseNextAttack.shuffle()
		
		return chooseNextAttack[0]
	
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.desaccelete(parent.motion.x)
	
	randomize()
	
	parent.playback.travel("IDLE")



