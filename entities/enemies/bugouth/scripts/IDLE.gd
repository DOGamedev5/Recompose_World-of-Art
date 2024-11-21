extends State

func process_state():

	if parent.player:
		return "ATTACK"
