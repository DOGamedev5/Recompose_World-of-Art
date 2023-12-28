extends PlayerBase

onready var sprite = $Sprite
onready var animation = $AnimationTree
onready var stateMachine = $StateMachine
onready var playback = animation["parameters/playback"]
onready var attackComponents = [$attackPunch, $attackSpeed]
onready var currentCollision = $CollisionShape2D

export(float) var runningVelocity := 550.0

var running := false
var canAttackTimer := .0
var attackTime := 20.0
var attackVelocity := 800.0

onready var collisionShapes := [
	{shape = RectangleShape2D.new(), position = Vector2(0, -20)},
	{shape = CapsuleShape2D.new(), position = Vector2(0, -20)},
	{shape = RectangleShape2D.new(), position = Vector2(0, -8)}
]

func _ready():
	stateMachine.init(self, currentState)
	collisionShapes[0].shape.extents = Vector2(12, 20)
	collisionShapes[1].shape.radius = 12
	collisionShapes[1].shape.height = 17
	collisionShapes[2].shape.extents = Vector2(12, 8)

func _physics_process(delta):
	stateMachine.processMachine(delta)
	_coyoteTimer()
	gravityBase()
	setFlipConfig()
	setAttackSpeed()
	
	animation["parameters/RUN/TimeScale/scale"] = max(0.5, (abs(motion.x) / MAXSPEED) * 3)
	
	motion = move_and_slide(motion, Vector2.UP)
	
	$Label.text = str(attackComponents[1].position)
	
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
	if stunned:
		return
	
	attackComponents[0].position.x = 24 *(1 - 2 * int(fliped))
	attackComponents[1].position.x = 28 *(1 - 2 * int(fliped))
#	attackComponents[1].position.x = 28 * motion.normalized().x
#	attackComponents[1].position.y = (6 * motion.normalized().y) - 23
	
	$speedEffect.position.x = 20 * (1 - 2 * int(fliped))
	$speedEffect.flip_h = fliped
	
	sprite.flip_h = fliped

func setAttackSpeed():
	if running:
		attackComponents[1].monitoring = true
		if abs(motion.x) < 550:
			attackComponents[1].setDamage(1)
		else:
			attackComponents[1].setDamage(2)
	
	else:
		attackComponents[1].monitoring = false


func _on_HitboxComponent_area_entered(area):
	if area is ChangeRoom:
		area.changeRoom()

func setCollision(ID := 0):
	currentCollision.set_shape(collisionShapes[ID].shape)
	currentCollision.position = collisionShapes[ID].position
	
