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
	parent.lockRotate = true
	
	for obj in parent.enteredObjects:
		if obj.is_in_group("ladder"):
			parent.position = obj.global_position
			break

func process_state():
	if Global.handInput("ui_jump", false, parent.OwnerID) and parent.couldUncounch():
		return "JUMP"
	
	var input := Global.handInputAxis("ui_left", "ui_right", parent.OwnerID)
	
	var exitLadder := false
	if input:
		exitLadder = Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left") 
	
	if not parent.canLadder or (Global.handInput("ui_left", false, parent.OwnerID) or Global.handInput("ui_right", false, parent.OwnerID)):
		return "FALL"

		
	
	return null

func process_physics(_delta):
	var input := sign(Global.handInputAxis("ui_up", "ui_down", parent.OwnerID))
	var exitLadder := false
	
	parent.motion.y = input * 400
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
	parent.lockRotate = false
