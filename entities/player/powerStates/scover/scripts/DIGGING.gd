extends State

func enter(_ls):
	parent.snapDesatived = true
	parent.raycastShape.disabled = true

func process_state():
	if parent.canDig:
		return null
		
	if parent.motion.y > 0:
		return "FALL"

	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
			
		return "WALK"
	
	
	return null

func process_physics(delta):
	var input := Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)
	
	parent.spriteGizmo.rotation -= deg2rad(20) * input * delta
	
	var direction := Vector2(cos(parent.spriteGizmo.rotation), sin(parent.spriteGizmo.rotation))
	
	parent.motion = direction * parent.diggingVelocity
#	parent.motion.x = 0
#	parent.motion.y = parent.driveVelocity
	

func exit():
	parent.snapDesatived = false
	parent.raycastShape.disabled = false
	parent.spriteGizmo.rotation = 0
