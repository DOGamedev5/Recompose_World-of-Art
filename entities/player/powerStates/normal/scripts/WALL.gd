extends State

var currentState

func enter(lastState):
	if not parent.onFloor() or ["TOP_SPEED", "ATTACK", "ROLL"].has(lastState):
		parent.playback.travel("SPLAT")
		parent.stunned = true

	elif parent.onFloor() and abs(parent.motion.x) <= parent.MAXSPEED:
		parent.playback.travel("WALL")
	
	if parent.motion.y < 0:
		parent.motion.y /= 2
		
	parent.running = false


func process_state():
	if not parent.onFloor():
		if not parent.onWall():
			return "FALL"


	if parent.onFloor():
		if Input.get_axis("ui_left", "ui_right") == 0:
			return "IDLE"
			
		elif not parent.onWall():
			return "RUN"
	
	if parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	return null

func process_physics(_delta):
	if not parent.stunned:
		parent.moveBase("X", parent.motion.x)
	
	if parent.onFloor():
		parent.stunned = false
	
func exit():
	parent.stunned = false

