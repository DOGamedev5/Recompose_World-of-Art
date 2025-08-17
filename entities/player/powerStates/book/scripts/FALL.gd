extends State

onready var fallSFX : AudioStream = preload("res://entities/player/powerStates/book/sfxs/closeBookSFX.ogg")

func enter(_ls):
	parent.MAXFALL = 600

func process_state():
	if parent.onFloor():
		if parent.canJump and not parent.cinematic and parent.jumpBuffer:
			return "JUMP"
		
		if parent.motion.x == 0: return "IDLE"
			
		return "WALK"

func process_physics(_delta):
	if abs(parent.motion.x) < 250 and int(parent.realMotion.x) == 0:
		parent.motion.x = 0
		
	parent.moveBase("X", parent.motion.x)
	parent.playback.travel("FALL")

func exit():
	parent.MAXFALL = 100
	
	if parent.onFloor():
		AudioManager.playSFX(fallSFX, {"volume_db" : -15, "pitch_scale" : rand_range(0.95, 1.3)}, true, parent.global_position, 256)
