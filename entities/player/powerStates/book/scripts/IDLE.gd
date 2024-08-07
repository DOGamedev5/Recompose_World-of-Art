extends State

func process_state():
	if not parent.onFloor():
		return "FLY"
	
	if not parent.moving:
		return null
		
	elif Input.get_axis("ui_left", "ui_right")and not parent.cinematic:
		return "WALK"
	
	elif parent.canJump and not parent.cinematic and Input.is_action_pressed("ui_jump"):
		return "JUMP"

	return null
	
func process_physics(_delta):
	parent.idleBase()
	parent.playback.travel("IDLE")
