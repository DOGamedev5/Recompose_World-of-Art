extends State 

## innitil call
func enter(_lastState):
	parent.motion.x = 0
	parent.isDigging = false

## exit call
func exit():
	pass

## process_state its called in _physics_process
func process_state():
	if Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) != 0:
		return "WALK"
	
	elif Global.handInput("attack", parent.OwnerID) and parent.canDig:
		return "DRIVE"
	
	if parent.canJump and parent.jumpBuffer:
		return "JUMP"
	
	if not parent.onFloor():
		return "FALL"
		
	return null
	
## process_physics its called in _physics_process
func process_physics(_delta):
	parent.playback.travel("IDLE")
