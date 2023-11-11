extends PlayerBase

onready var onWall = $onWall
onready var sprite = $Sprite
onready var animation = $AnimationTree
onready var stateMachine = $StateMachine
onready var playback = animation["parameters/playback"]

export(float) var runningVelocity := 550.0
var running := false

func _ready():
	stateMachine.init(self)

func _physics_process(_delta):
	$Label.text = str(motion.x)
	stateMachine.processMachine(_delta)
	_coyoteTimer()
	gravityBase()
	
	sprite.flip_h = fliped
	onWall.cast_to.x = 20 * (1 - 2 * int(fliped))
	animation["parameters/RUN/TimeScale/scale"] = max(0.5, (abs(motion.x) / MAXSPEED) * 3)
	
	motion = move_and_slide(motion, Vector2.UP)

