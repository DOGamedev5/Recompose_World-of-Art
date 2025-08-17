extends State

var direction := 1.0

func enter(_lastState):

	parent.attackComponents[2].setDamage(2)
	parent.setParticle(0, false)
	parent.setParticle(1, true)
	parent.snapDesatived = false

	direction = sign(parent.motion.x)
	
	if parent.motion.y < 0:
		parent.motion.y = 0
	
	parent.isRolling = true
	parent.setCollision(1)

func process_state():
	if parent.onWall():
		return "WALL"
		
	elif parent.canJump and Global.handInput("ui_jump", true, parent.OwnerID) and parent.couldUncounch():
		return "JUMP"

	return null

func process_physics(_delta):
	parent.playback.travel("RUN")
	parent.topSpeedPlayback.travel("SUPERROLL")
	
	parent.motion.x = parent.runningVelocity * direction
	
	parent.setParticle(1, parent.onFloor())


func exit():
	parent.topSpeedPlayback.travel("RUN")
	parent.attackComponents[2].setDamage(0)
	parent.setParticle(0, false)
	parent.setCollision(0)
	parent.isRolling = false
