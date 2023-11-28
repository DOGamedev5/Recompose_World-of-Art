extends PlayerBase

onready var onWallRayCast = [$onWallTop, $onWall, $onWallBotton]
onready var sprite = $Sprite
onready var animation = $AnimationTree
onready var stateMachine = $StateMachine
onready var playback = animation["parameters/playback"]
onready var attackDamage = $attack

export(float) var runningVelocity := 550.0

var running := false
var canAttackTimer := .0
var attackTime := 20.0
var attackVelocity := 800.0

func _ready():
	stateMachine.init(self, currentState)

func _physics_process(delta):
	stateMachine.processMachine(delta)
	_coyoteTimer()
	gravityBase()
	if not stunned:
		for ray in onWallRayCast:
			ray.cast_to.x = 20 * Input.get_axis("ui_left", "ui_right") 
		
		sprite.flip_h = fliped
	
	animation["parameters/RUN/TimeScale/scale"] = max(0.5, (abs(motion.x) / MAXSPEED) * 3)
	
	motion = move_and_slide(motion, Vector2.UP)
	
	$Label.text = str(attackDamage.monitoring, $attack.damage)
	
		
	if canAttackTimer > 0:
		canAttackTimer -= delta
		if canAttackTimer < 0:
			canAttackTimer = 0

func onWall():
	for ray in onWallRayCast:
		if ray.is_colliding():
			return true
	
	return false

