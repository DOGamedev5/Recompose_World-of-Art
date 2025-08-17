extends State

onready var swordFloor := [
	$"../../sprite/swordFloor2",
	$"../../sprite/swordFloor",
]
onready var sword := $"../../sprite/Sword"

func enter(_laststate):
	parent.setParticle(0, false)
	parent.setParticle(1, false)
	if Players.getPlayerCharater(parent.OwnerID) == "alexandry":
		
		if swordFloor[int(parent.fliped)].is_colliding():
			sword.position.x = 24 * (1 - 2*int(parent.fliped))
		else:
			sword.position.x = -24 * (1 - 2*int(parent.fliped))
		
		sword.offset.y = -12
		sword.rotation_degrees = rand_range(-10, 2) * (1 - 2*int(parent.fliped))
		sword.visible = true


func process_state():
	if not parent.moving:
		return null
		
	if parent.onSlope() and Global.handInput("ui_down", parent.OwnerID):
		return "ROLL"
		
	elif Global.handInputAxis("ui_left", "ui_right", parent.OwnerID) != 0 and not parent.cinematic:
		if Input.is_action_pressed("run") and parent.couldUncounch(true):
			return "RUN"
		
		return "WALK"

	elif parent.canJump and not parent.cinematic and parent.jumpBuffer and parent.couldUncounch(true):
		return "JUMP"
	
	elif not parent.onFloor():
		return "FALL"
	
	elif Global.handInput("attack", parent.OwnerID) and parent.canAttack and parent.couldUncounch(true):
		return "ATTACK"
	
	if Global.handInputAxis("ui_up", "ui_down", parent.OwnerID) and parent.canLadder:
		return "LADDER"

	return null
	
func process_physics(delta):
	parent.idleBase()
	
	if Players.getPlayerCharater(parent.OwnerID) == "alexandry" and sword.offset.y != 8:
		sword.offset.y = lerp(sword.offset.y, -8, delta*20)
	
	if not Network.is_owned(parent.OwnerID): return
	
	if parent.counched:
		parent.playback.travel("COUNCH")
	else:
		parent.playback.travel("NORMAL")
	
	if not parent.is_on_floor():
		if parent.counched:
			parent.counchPlayback.travel("COUNCHFALL")
		else:
			parent.normalPlayback.travel("FALL")
		
	else:
		if parent.counched:
			parent.counchPlayback.travel("COUNCH")
		else:
			parent.normalPlayback.travel("IDLE")
	

func exit():
	sword.visible = false
	
