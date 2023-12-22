extends State

var currentState

func enter(lastState):
	
	if not parent.floorDetect.is_colliding() or ["TOP_SPEED", "ATTACK"].has(lastState):
		parent.playback.travel("SPLAT")
		parent.stunned = true

	elif parent.floorDetect.is_colliding() and abs(parent.motion.x) <= 500:
		parent.playback.travel("WALL")
	
	if parent.motion.y < 0:
		parent.motion.y /= 2
	parent.running = false

func process_state():
	if not parent.floorDetect.is_colliding():
		if not parent.onWall():
			return "FALL"


	if parent.floorDetect.is_colliding():
		if Input.get_axis("ui_left", "ui_right") == 0:
			return "IDLE"
			
		elif not parent.onWall():
			return "RUN"
	
	elif parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	return null

func process_physics(_delta):
	if not parent.stunned:
		parent.motion.x = parent.moveBase("X", parent.motion.x)
	
	if parent.floorDetect.is_colliding():
		parent.stunned = false
	

func exit():
	parent.stunned = false

