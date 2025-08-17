extends State

func enter(_ls):
	parent.animationPlayback.travel("toattack")
	parent.motion.x = 0
	
func process_state():
	if parent.animationPlayback.get_current_node() == "toattack" and (parent.animationPlayback.get_current_length() == parent.animationPlayback.get_current_play_position()):
		return "ATTACK"
