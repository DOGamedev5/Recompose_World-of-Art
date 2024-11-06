extends State

onready var flipSFX : AudioStream = preload("res://entities/player/powerStates/book/sfxs/bookStep2SFX.ogg")

func enter(_ls):
	
	AudioManager.playSFX(parent.stepSFX)
	parent.MAXSPEED = 750
	parent.snapDesatived = true

func process_state():
	if parent.jumpBuffer or parent.is_on_wall():
		return "FALL"
	
	elif parent.onFloor():
		if parent.motion.x == 0: return "IDLE"
		
		return "WALK"
	
	return null

func process_physics(_delta):
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
		
	parent.moveBase("X", parent.motion.x)
	parent.playback.travel("FLY")

func exit():
	parent.MAXSPEED = 600
	parent.snapDesatived = false

