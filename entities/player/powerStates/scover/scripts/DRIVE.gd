extends State

onready var driveTimer := $driveTimer

func enter(_ls):
	parent.snapDesatived = true
	parent.raycastShape.disabled = true

	var smoke = load("res://objects/dustBlow/dustBlow.tscn").instance()
	smoke.amount = 8
	parent.get_parent().add_child(smoke)
	smoke.lifetime = 0.5
	smoke.preprocess = 0.2
	smoke.global_position = parent.global_position - Vector2(0, 32)
	
	driveTimer.start()
	
	parent.motion.y = parent.driveVelocity
	parent.gravity = false
	parent.motion.x = 0
	parent.canJump = false
	parent.isDigging = true
	parent.playback.travel("DRIVE")

func process_state():
	if not driveTimer.is_stopped() and not parent.collider.is_colliding():
		return null
	
	if parent.canDig:
		return "DIGGING"
	
	if not parent.onFloor():
		return "FALL"

	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
			
		return "WALK"
	
	return null

func process_physics(_delta):
	parent.motion.x = 0
	parent.motion.y = parent.driveVelocity

func exit():
	parent.snapDesatived = false
	parent.raycastShape.disabled = false
	parent.gravity = true
	
