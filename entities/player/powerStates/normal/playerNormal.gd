extends PlayerBase

onready var onWallRayCast = [$onWallTop, $onWall, $onWallBotton]
onready var sprite = $Sprite
onready var animation = $AnimationTree
onready var stateMachine = $StateMachine
onready var playback = animation["parameters/playback"]

export(float) var runningVelocity := 550.0

var running := false


func _ready():
	stateMachine.init(self, currentState)

func _physics_process(_delta):
	stateMachine.processMachine(_delta)
	_coyoteTimer()
	gravityBase()
	if not stunned:
		for ray in onWallRayCast:
			ray.cast_to.x = 20 * Input.get_axis("ui_left", "ui_right") 
		
		sprite.flip_h = fliped
	
	animation["parameters/RUN/TimeScale/scale"] = max(0.5, (abs(motion.x) / MAXSPEED) * 3)
	
	motion = move_and_slide(motion, Vector2.UP)
	
	$Label.text = str(stateMachine.currentState.name == "ATTACK")

func onWall():
	for ray in onWallRayCast:
		if ray.is_colliding():
			return true
	
	return false
