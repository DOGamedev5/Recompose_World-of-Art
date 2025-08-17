extends State

func enter(_ls):
	parent.snapDesatived = true
	parent.circleShape.disabled = true
	parent.raycastShape.disabled = true
	parent.raycastDirectional.disabled = false
	parent.gravity = false
	

func process_state():
	if parent.canDig:
		return null
		
	if parent.motion.y > 0 or not parent.onFloor():
		return "FALL"

	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
			
		return "WALK"
	
	return null

func process_physics(_delta):
	var input := Vector2(
		Global.handInputAxis("ui_left", "ui_right", parent.OwnerID),
		Global.handInputAxis("ui_up", "ui_down", parent.OwnerID)
	).normalized()
	
	if input:
		parent.spriteGizmo.rotation = input.angle() - PI/2
	else:
		input = Vector2(cos(parent.spriteGizmo.rotation + PI/2), sin(parent.spriteGizmo.rotation + PI/2))
	
	parent.motion = input * parent.diggingVelocity
	

func exit():
	parent.snapDesatived = false
	parent.raycastShape.disabled = false
	parent.circleShape.disabled = false
	parent.raycastDirectional.disabled = true
	parent.spriteGizmo.rotation = 0
#	parent.motion.y = 0
	parent.gravity = true
