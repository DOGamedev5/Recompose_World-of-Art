extends State

func enter(_ls):
	parent.motion = Vector2.ZERO
	parent.animationPlayback.travel("IDLE")

func process_state():

	if parent.player:
		return "SEEK"
