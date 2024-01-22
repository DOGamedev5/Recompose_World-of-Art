extends PlayerBase

onready var sprite = $Sprite
onready var animation = $AnimationTree
onready var playback = animation["parameters/playback"]
onready var attackComponents = [$attackPunch, $attackSpeed, $attackRoll]
onready var currentCollision = $CollisionShape2D

export(float) var runningVelocity := 550.0

export var running := false
var canAttackTimer := .0
var attackTime := 20.0
var attackVelocity := 800.0
var isRolling := false

onready var runningParticle = $runningParticle

onready var collisionShapes := [
	{shape = CapsuleShape2D.new(), position = Vector2(0, -28), onWall = [true, true, true]},
	{shape = CircleShape2D.new(), position = Vector2(0, -16), onWall = [false, false, true]}
]

func _ready():
	
	collisionShapes[0].shape.radius = 16
	collisionShapes[0].shape.height = 24
	collisionShapes[1].shape.radius = 15
	
func _physics_process(delta):
	if not active: return
	
	_coyoteTimer()
	setFlipConfig()
	setAttackSpeed()
	
	animation["parameters/RUN/TimeScale/scale"] = max(0.5, (abs(motion.x) / MAXSPEED) * 3)
	
	if active:
		move(!isRolling)
	
#	$a/Label.text = str(canLadder) +" \n " + str(motion) + "  " + str(snapDesatived)

	$speedEffect.visible = running
	if running:
		$speedEffect.modulate.a = max((sqrt(pow(motion.x, 2) + pow(motion.y, 2)) - MAXSPEED) / (runningVelocity - MAXSPEED), 0.65)
		
	if canAttackTimer > 0:
		canAttackTimer -= delta
		if canAttackTimer < 0:
			canAttackTimer = 0


func setFlipConfig():
	if stunned:
		return
	
	attackComponents[0].position.x = 35 * (1 - 2 * int(fliped))
	attackComponents[1].position.x = 40 * (1 - 2 * int(fliped))

	attackComponents[1].position.y = (16 * motion.normalized().y) - 23
	attackComponents[2].position.x = 35 * (1 - 2 * int(fliped))
	
	$speedEffect.position.x = 28 * (1 - 2 * int(fliped))
	$speedEffect.flip_h = fliped
	
	sprite.flip_h = fliped

func setAttackSpeed():
	if running and not isRolling:
		attackComponents[1].monitoring = true
		if sqrt(pow(motion.x, 2) + pow(motion.y, 2)) < 725:
			attackComponents[1].setDamage(1)
		else:
			attackComponents[1].setDamage(2)
	
	else:
		attackComponents[1].monitoring = false
	
	attackComponents[2].monitoring = isRolling

func setCollision(ID := 0):
	active = false
	currentCollision.set_deferred("position", collisionShapes[ID].position)
	currentCollision.set_deferred("shape", collisionShapes[ID].shape)
	currentCollision.set_deferred("custom_solver_bias", 0.2)
	
	for ray in range(2):
		onWallRayCast[ray].enabled = collisionShapes[ID].onWall[ray]
	
	active = true
