extends State

func enter(_ls):
	parent.animationPlayback.travel("walk")
	parent.timer.wait_time = rand_range(1.4, 3.7)
	parent.timer.start()
	
	if rand_range(0.0, 1.0) < 0.6:
		parent.fliped = !parent.fliped
	
func process_state():
	if parent.cooldown.is_stopped() and parent.playerInArea: return "TOATTACK"
	
	if parent.timer.is_stopped():
		return "IDLE"

func process_physics(_delta):
	parent.motion.x = -parent.MAXSPEED if parent.fliped else parent.MAXSPEED
