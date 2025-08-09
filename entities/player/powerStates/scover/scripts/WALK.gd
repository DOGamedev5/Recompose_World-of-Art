extends State 

## innitil call
func enter(_lastState):
	parent.isDigging = false
#	$"../../CollisionShape2D2".disabled = false

## exit call
func exit():
	pass

## process_state its called in _physics_process
func process_state():
	if Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) == 0 and parent.motion.x == 0:
		return "IDLE"
	
	elif Global.handInput("attack", parent.OwnerID) and parent.canDig:
		return "DRIVE"
	
	if parent.canJump and parent.jumpBuffer:
		return "JUMP"
		
	return null
	
## process_physics its called in _physics_process
func process_physics(_delta):
	var input := Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)
	
	parent.motion.x = input * parent.MAXSPEED
	
	if input != 0:
		parent.playback.travel("WALK")
