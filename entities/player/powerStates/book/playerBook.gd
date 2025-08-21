extends PlayerBase

onready var animationTree := $AnimationTree
onready var playback = animationTree["parameters/playback"]

onready var stepSFX : AudioStream = preload("res://entities/player/powerStates/book/sfxs/bookStep2SFX.ogg")

var onVentoy := false

func _ready():
	$sprite.material["shader_param/hue_shift"] = Players.playerList[OwnerID].colorShift

func _physics_process(delta):
	physics_process(delta)
	move()
	_coyoteTimer()
#	rotateSprite(delta)
	
	$sprite/sprite.flip_h = fliped
	
	if not onFloor():
		$sprite/sprite.rotation = lerp_angle($sprite.rotation, deg2rad(15) * (realMotion.x / MAXSPEED), 0.5)
	else:
		$sprite/sprite.rotation = lerp_angle($sprite.rotation, deg2rad(5) * (realMotion.x / MAXSPEED), 0.5)

func move():
	var snap := Vector2.ZERO
	if not (snapDesatived or onVentoy):
		
		snap = Vector2.DOWN * SNAPLENGTH

	if motion: detectInside()
	
	motion = move_and_slide_with_snap(motion, Vector2.DOWN*snap, Vector2.UP, true) 
	currentSnapLength = snap.y

func updateHueshift(newShift : int):
	.updateHueshift(newShift)
	$sprite.material["shader_param/hue_shift"] = Players.playerList[OwnerID].colorShift

func _step():
	
	AudioManager.playSFX(stepSFX, {"volume_db" : -0.5, "pitch_scale" : rand_range(0.85, 1.2)}, true, global_position, 256)
	
