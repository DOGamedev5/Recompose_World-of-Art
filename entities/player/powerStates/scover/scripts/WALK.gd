extends State 

## innitil call
#func enter(_lastState):
#	$"../../CollisionShape2D2".disabled = false

## exit call
func exit():
	pass

## process_state its called in _physics_process
func process_state():
	if Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) == 0 and parent.motion.x == 0:
		return "IDLE"
	
	return null
	
## process_physics its called in _physics_process
func process_physics(_delta):
	var input := Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)
	
	parent.moveBase("X", parent.motion.x)
	
	if input != 0:
		parent.playback.travel("WALK")
