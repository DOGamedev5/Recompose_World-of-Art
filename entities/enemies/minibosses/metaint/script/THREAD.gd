extends State


func process_physics(_delta):
	parent.playback.travel("THREAD")
	

func process_state():
	if parent.active:
		return "IDLE"
	
	return null
	
