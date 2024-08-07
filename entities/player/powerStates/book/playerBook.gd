extends PlayerBase

onready var animationTree := $AnimationTree
onready var playback = animationTree["parameters/playback"]

func _physics_process(_delta):
	move()
	_coyoteTimer()
	
	$BookIdle.flip_h = fliped
