extends State

func enter(_ls):
	parent.animationPlayback.travel("idle")
	parent.motion.x = 0
	parent.timer.wait_time = rand_range(0.4, 2.2)
	parent.timer.start()
	
func process_state():
	if parent.cooldown.is_stopped() and parent.playerInArea: return "TOATTACK"
	
	if parent.timer.is_stopped():
		return "WALK"
	
