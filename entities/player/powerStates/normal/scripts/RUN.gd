extends State


func enter(_lastState):
	parent.playback.travel("RUN")
	parent.running = false

func process_state():
	if parent.onWall():
		return "WALL"
			
	if parent.motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0 :
		return "IDLE"
		
	elif parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif not parent.floorDetect.is_colliding():
		return "FALL"
	
	elif Input.is_action_pressed("run"):
		return "TOP_SPEED"
	
	elif Input.is_action_just_pressed("attack"):
		return "ATTACK"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.moveBase("X", parent.motion.x)
	var input := Input.get_axis("ui_left", "ui_right")
	
	if sign(parent.motion.x) != sign(input) and parent.motion.x != 0:
		parent.playback.travel("STOPPING")
	elif input != 0:
		parent.playback.travel("RUN")
