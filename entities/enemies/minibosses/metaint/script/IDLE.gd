extends State

onready var timer = $Timer

var attacked := false

func enter(lastState):
	if lastState != "ATTACK":
		attacked = false
	
	if parent.active:
		timer.wait_time = rand_range(1.5, 2.1)
		timer.start()

func process_state():
	
	if not parent.active: return null
	
	if parent.areas.sword and timer.time_left < timer.wait_time - 0.8:
		timer.stop()
		if attacked:
			return "TOJUMP"
		
		attacked = true
		return "TOATTACK"
	
	elif parent.areas.jump and timer.time_left < timer.wait_time - 1.2:
		timer.stop()
		return "TOJUMP"
	
	elif timer.is_stopped():
		return "TORUN"
 
	if parent.position.x < 224 or parent.position.x > 1312:
		return "WALK"
		
	return null

func process_physics(_delta):
	parent.motion.x = parent.desaccelete(parent.motion.x)
	
	randomize()
	
	parent.playback.travel("IDLE")
	$"../../Metaint".flip_h = parent.fliped



