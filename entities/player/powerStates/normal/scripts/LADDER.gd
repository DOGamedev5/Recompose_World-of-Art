extends State

onready var seek = $"../../AnimationTree"["parameters/LADDER/Seek/seek_position"]

var lastAnimation := -1.0

func enter(_lastState):
	parent.setParticle(0, false)
	parent.setParticle(1, false)
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
	
	if not parent.canLadder or (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")):
		return "FALL"
	
	return null

func process_physics(_delta):
	var input := Input.get_axis("ui_up", "ui_down")
	parent.motion.y = input * 300
	if input == 0:
		parent.ladderPlayback.stop()
	elif input != lastAnimation:
		
		var position = 0.4 - parent.ladderPlayback.get_current_play_position()
		seek = position
		
	if input == 1:
		if not parent.ladderPlayback.is_playing():
			parent.ladderPlayback.start("LADDERUP")
		else:
			parent.ladderPlayback.travel("LADDERUP")
		lastAnimation = input
	
	elif input == -1:
		if not parent.ladderPlayback.is_playing():
			parent.ladderPlayback.start("LADDERUP")
		else:
			parent.ladderPlayback.travel("LADDERDOWN")
		lastAnimation = input
		
func exit():
	parent.motion.y = -500
	parent.snapDesatived = false
	parent.gravity = true
