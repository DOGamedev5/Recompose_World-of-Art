extends PlayerBase

onready var animationTree := $AnimationTree
onready var playback = animationTree["parameters/playback"]

func _physics_process(_delta):
	move()
	_coyoteTimer()
	
	$sprite.flip_h = fliped
	
	if not onFloor():
		$sprite.rotation = lerp_angle($sprite.rotation, deg2rad(15) * (realMotion.x / MAXSPEED), 0.5)
	else:
		$sprite.rotation = lerp_angle($sprite.rotation, deg2rad(5) * (realMotion.x / MAXSPEED), 0.5)
