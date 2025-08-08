extends State 

## innitil call
#func enter(_lastState):
#	$"../../CollisionShape2D2".disabled = false

## exit call
func exit():
	pass

## process_state its called in _physics_process
func process_state():
	if Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) != 0:
		return "WALK"
	
	
	return null
	
## process_physics its called in _physics_process
func process_physics(_delta):
	parent.playback.travel("IDLE")
	pass
