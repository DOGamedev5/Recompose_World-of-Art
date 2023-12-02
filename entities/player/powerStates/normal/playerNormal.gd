extends PlayerBase

onready var onWallRayCast = [$onWallTop, $onWall, $onWallBotton]
onready var sprite = $Sprite
onready var animation = $AnimationTree
onready var stateMachine = $StateMachine
onready var playback = animation["parameters/playback"]
onready var attackComponents = [$attackPunch, $attackSpeed]

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
	setFlipConfig()
	
	animation["parameters/RUN/TimeScale/scale"] = max(0.5, (abs(motion.x) / MAXSPEED) * 3)
	
	motion = move_and_slide(motion, Vector2.UP)
	
#	$Label.text = str()
	
	$speedEffect.visible = running
	if running:
		$speedEffect.modulate.a = max((abs(motion.x) - MAXSPEED) / (runningVelocity - MAXSPEED), 0.65)
		
	
	if canAttackTimer > 0:
		canAttackTimer -= delta
		if canAttackTimer < 0:
			canAttackTimer = 0

func onWall():
	for ray in onWallRayCast:
		if ray.is_colliding():
			return true
	
	return false

func setFlipConfig():
	if not stunned:
		for ray in onWallRayCast:
			ray.cast_to.x = 20 * Input.get_axis("ui_left", "ui_right")
		
		
		attackComponents[0].position.x = 24 *(1 - 2 * int(fliped))
		attackComponents[1].position.x = 36 *(1 - 2 * int(fliped))
		
		$speedEffect.position.x = 20 * (1 - 2 * int(fliped))
		$speedEffect.flip_h = fliped
		
		sprite.flip_h = fliped

func setAttackSpeed():
	if running:
		attackComponents[1].monitoring = true
		if abs(motion.x) <+ 550:
			attackComponents[1].setDamage(1)
		else:
			attackComponents[1].setDamage(2)
	
	else:
		attackComponents[1].monitoring = false
