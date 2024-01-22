extends State

func enter(_lastState):
	parent.playback.travel("LADDER")
	parent.snapDesatived = true
	parent.gravity = false

func process_state():
	if Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	return null

func process_physics(_delta):
	var input := Input.get_axis("ui_up", "ui_down")
	parent.motion.y = input * 200
#	parent.moveBase("Y", parent.motion.y)

func exit():
	parent.snapDesatived = false
	parent.gravity = true
