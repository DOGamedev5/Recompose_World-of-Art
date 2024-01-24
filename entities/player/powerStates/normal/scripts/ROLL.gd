extends State

onready var particle = $"../../runningParticle"
var direction := 1

func enter(_lastState):
	parent.snapDesatived = false
	parent.playback.travel("ROLL")
	particle.emitting = true

	direction = sign(parent.getSlopeNormal().x)
	if direction == 0:
		direction = sign(parent.motion.x)

	parent.isRolling = true
	parent.setCollision(1)

func process_state():
	if parent.onWall():
		return "WALL"
		
	elif parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"

#	elif not parent.onFloor().has(true):
#		return "FALL"

	return null

func process_physics(_delta):
	var detect = sign(parent.getSlopeNormal().x)
	if detect:
		direction = detect
	parent.motion.x = parent.MAXSPEED * direction
	parent.motion.y = parent.MAXSPEED

func exit():
#	parent.snapDesatived = false
	particle.emitting = false
	parent.setCollision(0)
	parent.isRolling = false
