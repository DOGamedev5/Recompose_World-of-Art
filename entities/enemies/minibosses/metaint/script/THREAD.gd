extends State


func process_physics(_delta):
	parent.playback.travel("THREAD")
	

func process_state():
	if parent.playback.get_current_play_position() >= parent.playback.get_current_length():
		return "IDLE"
	
	return null
	
