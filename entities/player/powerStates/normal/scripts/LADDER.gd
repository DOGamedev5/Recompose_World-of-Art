extends State

func enter(_lastState):
	parent.playback.travel("LADDER")
	parent.motion.x = 0
	parent.snapDesatived = true
	parent.gravity = false
	parent.running = false
	for obj in parent.enteredObjects:
		if obj.is_in_group("ladder"):
			parent.position = obj.global_position
			break

func process_state():
	if Input.is_action_pressed("ui_jump") and parent.couldUncounch():
		return "JUMP"
	
	if not parent.canLadder:
		return "FALL"
	
	return null

func process_physics(_delta):
	var input := Input.get_axis("ui_up", "ui_down")
	parent.motion.y = input * 200

func exit():
	parent.snapDesatived = false
	parent.gravity = true
