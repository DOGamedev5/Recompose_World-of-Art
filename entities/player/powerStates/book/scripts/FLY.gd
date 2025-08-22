extends State

onready var flipSFX : AudioStream = preload("res://entities/player/powerStates/book/sfxs/bookStep2SFX.ogg")

func enter(_ls):
	
	AudioManager.playSFX(parent.stepSFX, {"volume_db" : 2.6, "pitch_scale" : rand_range(0.98, 1.3)}, true, parent.global_position, 256)
	parent.MAXSPEED = 850
	parent.snapDesatived = true

func process_state():
	if Global.handInput("attack", false, parent.OwnerID):
		return "FALL"
	
	elif parent.onFloor():
		parent.motion.x /= 4
		if parent.motion.x == 0: return "IDLE"
		
		
		return "WALK"
	
	return null

func process_physics(_delta):
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0 and not parent.onVentoy:
		parent.motion.x = 0
		
	parent.moveBase("X", parent.motion.x)
	parent.playback.travel("FLY")

func exit():
	parent.MAXSPEED = 750
	parent.snapDesatived = false

