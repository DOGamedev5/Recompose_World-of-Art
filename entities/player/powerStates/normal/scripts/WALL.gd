extends State

var splat := false

func enter(lastState):
	parent.playback.travel("WALLED")
	
	if not parent.onFloor() or ["TOP_SPEED", "ATTACK", "ROLL", "JUMP", "FALL"].has(lastState):
		parent.walledPlayback.travel("SPLAT")
		parent.lockRotate = true
		parent.stunned = true
		$"Timer".start()
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
		if Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) == 0:
			return "IDLE"
			
		elif not parent.onWall():
			return "WALK"
	
	if parent.jumpBuffer and $"Timer".is_stopped():
		if parent.canJump and parent.couldUncounch():
			return "JUMP"
		
		parent.motion.x = (1 - (int(parent.fliped) * 2)) * -200
		parent.motion.y = -500

		return "FALL"
	
	return null

func process_physics(_delta):
	if splat and not parent.onFloor():
		parent.walledPlayback.travel("SPLAT")
	
	if not parent.stunned:
		parent.moveBase("X", parent.motion.x)
	
	if parent.onFloor():
		parent.stunned = false
	
func exit():
	parent.lockRotate = false
	parent.stunned = false

