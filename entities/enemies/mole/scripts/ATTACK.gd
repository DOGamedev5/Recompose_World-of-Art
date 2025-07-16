extends State

func enter(_ls):
	parent.animationPlayback.travel("attack")
	parent.timer.wait_time = 0.4
	parent.timer.start()
	parent.motion.x = -400 if parent.fliped else 400
	parent.motion.y = -125
	parent.cooldown.wait_time = rand_range(2.5, 3.8)
	parent.cooldown.start()
	
func process_state():
	if parent.timer.is_stopped():
		return "IDLE"

func process_physics(delta):
	if parent.raycast.is_colliding():
		parent.motion.x = 0

