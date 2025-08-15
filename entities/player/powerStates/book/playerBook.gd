extends PlayerBase

onready var animationTree := $AnimationTree
onready var playback = animationTree["parameters/playback"]

onready var stepSFX : AudioStream = preload("res://entities/player/powerStates/book/sfxs/bookStep2SFX.ogg")

var onVentoy := false

func _physics_process(delta):
	physics_process(delta)
	snapDesatived = onVentoy or snapDesatived
	move()
	_coyoteTimer()
#	rotateSprite(delta)
	
	$sprite/sprite.flip_h = fliped
	
	if not onFloor():
		$sprite/sprite.rotation = lerp_angle($sprite.rotation, deg2rad(15) * (realMotion.x / MAXSPEED), 0.5)
	else:
		$sprite/sprite.rotation = lerp_angle($sprite.rotation, deg2rad(5) * (realMotion.x / MAXSPEED), 0.5)

func _step():
	
	AudioManager.playSFX(stepSFX, {"volume_db" : -2.5, "pitch_scale" : rand_range(0.95, 1.2)}, true, global_position, 256)
	
