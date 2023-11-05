extends PlayerBase

enum states {IDLE, RUN, JUMP, FALL, WALL}

var currentState : int = states.IDLE

onready var onWall = $onWall
onready var sprite = $Sprite
onready var animation = $AnimationTree
onready var playback = animation["parameters/playback"]

func _ready():
#	$StateMachine.startingState = "IDLE"
	$StateMachine.init(self)

func _physics_process(_delta):
	$StateMachine.processMachine(_delta)
	_coyoteTimer()
	gravityBase()
	animation["parameters/RUN/TimeScale/scale"] = max(0.5, (abs(motion.x) / MAXSPEED) * 3)
	
	sprite.flip_h = fliped
	onWall.cast_to.x = 12 * (1 - 2 * int(fliped))
	motion = move_and_slide(motion, Vector2.UP)
