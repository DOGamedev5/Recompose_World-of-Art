extends State

var direction := 1.0

func enter(_lastState):
	parent.attackComponents[2].setDamage(1)
	parent.setParticle(0, true)
	parent.setParticle(1, false)
	parent.snapDesatived = false

	direction = sign(parent.getSlopeNormal().x)
	if direction == 0 and parent.motion.x:
		direction = sign(parent.motion.x)
	elif direction == 0:
		direction = 1 - (int(parent.fliped)*2)

	parent.isRolling = true
	parent.setCollision(1)

func process_state():
	if parent.onWall():
		return "WALL"
		
	elif parent.canJump and Global.handInput("ui_jump", true, parent.OwnerID) and parent.couldUncounch():
		return "JUMP"

	return null

func process_physics(_delta):
	parent.playback.travel("NORMAL")
	parent.normalPlayback.travel("ROLL")
	
	var detect = sign(parent.getSlopeNormal().x)
	if detect and parent.onFloor():
		direction = detect
	elif parent.onWallRayCast[2].is_colliding():
		direction = sign(parent.onWallRayCast[2].get_collision_normal().x)
		
	parent.motion.x = parent.MAXSPEED * direction
	
	parent.setParticle(0, parent.onFloor())

func exit():
	parent.attackComponents[2].setDamage(0)
	parent.setParticle(0, false)
	parent.setCollision(0)
	parent.isRolling = false
