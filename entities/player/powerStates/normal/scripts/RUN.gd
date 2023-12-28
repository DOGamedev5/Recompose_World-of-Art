extends State


onready var particle = $"../../runningParticle"

func enter(_lastState):
	if Input.is_action_pressed("ui_down"):
		parent.playback.travel("CRAWLING")
		particle.emitting = false
	else:
		parent.playback.travel("RUN")
		particle.emitting = true
	
	parent.running = false
	
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
	
	elif Input.is_action_pressed("run"):
		return "TOP_SPEED"
	
	elif Input.is_action_just_pressed("attack") and parent.canAttackTimer == 0:
		return "ATTACK"
	
	return null

func process_physics(_delta):
#	particle.initial_velocity = -(min(abs(parent.motion.x), 100) * sign(parent.motion.x))
	
	var input := Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_pressed("ui_down"):
		parent.motion.x = parent.moveBase("X", parent.motion.x, 150)
		parent.playback.travel("CRAWLING")
		particle.emitting = false
		parent.setCollision(2)
	else:
		parent.motion.x = parent.moveBase("X", parent.motion.x)
		particle.emitting = true
		parent.setCollision(1)
		if sign(parent.motion.x) != sign(input) and parent.motion.x != 0:
			parent.playback.travel("STOPPING")
		elif input != 0:
			parent.playback.travel("RUN")

func exit():
	particle.emitting = false
	parent.setCollision(0)
	
