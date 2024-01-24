extends State

onready var ladderAnimation = $"../../AnimationTree"["parameters/LADDER/StateMachine/playback"]


onready var seek = $"../../AnimationTree"["parameters/LADDER/Seek/seek_position"]

var lastAnimation := -1

func enter(_lastState):
	
#	ladderAnimation.stop()
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
	parent.motion.y = input * 300
	if input == 0:
		ladderAnimation.stop()
	elif input != lastAnimation:
		
		var position = 0.4 - ladderAnimation.get_current_play_position()
		seek = position
		
	if input == 1:
		if not ladderAnimation.is_playing():
			ladderAnimation.start("LADDERUP")
		else:
			ladderAnimation.travel("LADDERUP")
		lastAnimation = input
	elif input == -1:
		if not ladderAnimation.is_playing():
			ladderAnimation.start("LADDERUP")
		else:
			ladderAnimation.travel("LADDERDOWN")
		lastAnimation = input
		
	

func exit():
	parent.snapDesatived = false
	parent.gravity = true
