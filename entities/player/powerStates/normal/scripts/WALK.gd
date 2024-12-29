extends State


func enter(_laststate):
	parent.setParticle(0, true)
	parent.setParticle(1, false)
	parent.running = false
	
	if abs(parent.motion.x) < 150:
		parent.motion.x = 150 * Input.get_axis("ui_left", "ui_right")

func process_state():
	if parent.motion.x == 0 and (Input.get_axis("ui_left", "ui_right") == 0 or not parent.moving) :
		return "IDLE"
		
	if (parent.onSlope() or abs(parent.motion.x) > 500) and Input.is_action_just_pressed("ui_down"):
		return "ROLL"
	
	if parent.onWall():
		return "WALL"
		
	elif parent.canJump and parent.jumpBuffer and parent.couldUncounch(true):
		return "JUMP"
	
	elif not parent.onFloor():
		return "FALL"
	
	elif Input.is_action_pressed("run") and parent.couldUncounch(true):
		return "RUN"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttack and parent.couldUncounch(true):
		return "ATTACK"
	
	elif (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and parent.canLadder:
		return "LADDER"

	
	return null

func process_physics(_delta):
	var input := Input.get_axis("ui_left", "ui_right")
	
	if parent.counched:
		parent.moveBase("X", parent.motion.x, 180)
		parent.playback.travel("COUNCH")
		parent.counchPlayback.travel("CRAWLING")
		parent.setParticle(0, false)
		
	elif parent.couldUncounch(true):
		parent.moveBase("X", parent.motion.x)
		parent.setParticle(0, true)
		
		parent.playback.travel("NORMAL")
		
		if sign(parent.motion.x) != sign(input) and parent.motion.x != 0:
			parent.normalPlayback.travel("STOPPING")
		elif input != 0:
			parent.normalPlayback.travel("WALK")
	
	parent.animation["parameters/NORMAL/NORMAL/WALK/TimeScale/scale"] = max(0.5, (abs(parent.motion.x) / parent.MAXSPEED) * 3)

func exit():
	parent.setParticle(0, false)

	
