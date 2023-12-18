extends State


onready var particle = $"../../runningParticle"

func enter(_lastState):
	parent.playback.travel("TOP_SPEED")
	particle.emitting = true
	
	if abs(parent.motion.x) > parent.MAXSPEED:
		parent.running = true
	parent.setCollision(1)

func process_state():
	if parent.onWall():
		return "WALL"
			
	if parent.motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0 :
		return "IDLE"
		
	elif parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif not parent.onFloor().has(true):
		return "FALL"
	
	elif not Input.is_action_pressed("run") :
		return "RUN"
	
	return null

func process_physics(_delta):
	
	parent.motion.x = parent.moveBase("X", parent.motion.x, parent.runningVelocity)
	if abs(parent.motion.x) > parent.MAXSPEED:
		parent.running = true
	else:
		parent.running = false
	
	if sign(parent.motion.x) != sign(Input.get_axis("ui_left", "ui_right")) and parent.motion.x != 0:
		parent.playback.travel("STOPPING")
	else:
		parent.playback.travel("TOP_SPEED")

func exit():
	particle.emitting = false
	if not parent.running or abs(parent.motion.x) <= parent.MAXSPEED:
		parent.attackComponents[1].monitoring = false
		
	parent.setCollision(0)
