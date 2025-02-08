extends State

var currentTaunt : String

const tauntTimes := {
	"ENTER" : 0.6,
	"EXIT" : 0.6
}

func update():
	parent.playback.travel("TAUNT")
	parent.tauntPlayback.travel(currentTaunt)
	$Timer.wait_time = 0.5 if not tauntTimes.has(currentTaunt) else tauntTimes[currentTaunt]
	$Timer.start()

func process_state():
	if not $Timer.is_stopped(): return null
	
	if parent.canJump and parent.jumpBuffer and parent.couldUncounch():
		return "JUMP"
	
	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
		
		if parent.isRolling: return "ROLL"
		
		if Global.handInput("run", true): return "RUN"
		
		return "WALK"
	
	elif Global.handInput("attack") and parent.canAttack:
		return "ATTACK"
	
	elif Global.handInputAxis("ui_up", "ui_down") and parent.canLadder:
		return "LADDER"
	
	return null

func exit():
	pass
