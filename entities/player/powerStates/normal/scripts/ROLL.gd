extends State

onready var particle = $"../../runningParticle"
var direction := 1

func enter(_lastState):
	parent.playback.travel("ROLL")
	particle.emitting = true
#	print(parent.onSlope()[1].x)
	direction = sign(parent.onSlope()[1].x)
	parent.isRolling = true
	parent.setCollision(1)

func process_state():
	if sign(parent.motion.x) != direction:
		return "WALL"
		
	elif parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	elif not parent.onFloor().has(true):
		return "FALL"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.MAXSPEED * direction
	parent.motion.y = parent.MAXSPEED

func exit():
	particle.emitting = false
	parent.setCollision(0)
	parent.isRolling = false
