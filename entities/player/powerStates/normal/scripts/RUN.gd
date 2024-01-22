extends State


onready var particle = $"../../runningParticle"

func enter(_laststate):
	parent.running = false

func process_state():
	if parent.onSlope() and Input.is_action_just_pressed("ui_down"):
		return "ROLL"
	
	if parent.onWall():
		return "WALL"
			
	if parent.motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0 :
		return "IDLE"
		
	elif parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	elif not parent.onFloor().has(true):
		return "FALL"
	
	elif Input.is_action_pressed("run"):
		return "TOP_SPEED"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttackTimer == 0 and parent.couldUncounch(true):
		return "ATTACK"
	
	elif Input.is_action_just_pressed("ui_up") and parent.canLadder:
		return "LADDER"

	
	return null

func process_physics(_delta):
	
	var input := Input.get_axis("ui_left", "ui_right")
	
	if parent.counched:
		parent.moveBase("X", parent.motion.x, 180)
		parent.playback.travel("CRAWLING")
	else:
		parent.moveBase("X", parent.motion.x)
		
		if sign(parent.motion.x) != sign(input) and parent.motion.x != 0:
			parent.playback.travel("STOPPING")
		elif input != 0:
			parent.playback.travel("RUN")

func exit():
	particle.emitting = false

	
