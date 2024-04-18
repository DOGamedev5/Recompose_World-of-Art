extends State

var splat := false

func enter(lastState):
	parent.playback.travel("WALLED")
	
	if not parent.onFloor() or ["TOP_SPEED", "ATTACK", "ROLL", "JUMP", "FALL"].has(lastState):
		parent.walledPlayback.travel("SPLAT")
		parent.stunned = true
		splat = true

	elif parent.onFloor() and abs(parent.motion.x) <= parent.MAXSPEED:
		splat = false
		parent.walledPlayback.travel("WALL")
	
	if parent.motion.y < 0:
		parent.motion.y /= 2
		
	parent.running = false


func process_state():
	if not parent.onFloor():
		if not parent.onWall() or not splat:
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
	if splat and not parent.onFloor():
		parent.walledPlayback.travel("SPLAT")
	
	if not parent.stunned:
		parent.moveBase("X", parent.motion.x)
	
	if parent.onFloor():
		parent.stunned = false
	
func exit():
	parent.stunned = false

