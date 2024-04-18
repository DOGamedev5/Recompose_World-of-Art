class_name EnemyBase extends KinematicBody2D

export(NodePath) var visionArea
export(Array, NodePath) var attackAreaArray 
export(NodePath) var stateMachinePath
export(NodePath) var hitboxArea

var stateMachine

export var maxHealth := 20
export var health := 20

export var flipArea := false

export var ACCELERATION := 3
export var DESACCELERATION := 20
export var GravityForce := 10
export var MAXSPEED := 350
export var MAXFALL := 300
export var gravity := true
export var unlimitedVision  := false

var motion := Vector2.ZERO
var player = null
var fliped := false
var flipLock := false

signal enteredVision(body)
signal exitedVision(body)
signal defeated(enemy)

func _ready():
	if visionArea:
		visionArea = get_node(visionArea)
		visionArea.connect("body_entered", self, "_enteredVision")
		visionArea.connect("body_exited", self, "_exitedVision")
	
	if hitboxArea:
		hitboxArea = get_node(hitboxArea)
		hitboxArea.connect("HitboxDamaged", self, "hitted")
	
	if stateMachinePath:
		stateMachine = get_node(stateMachinePath)
		stateMachine.init(self)

func gravityProcess():
	if not onFloor():
		
		motion.y += GravityForce
		if motion.y > MAXFALL:
			motion.y = MAXFALL

func _physics_process(delta):
	if stateMachine:
		stateMachine.processMachine(delta)
	
	gravityProcess()
	
	if player and not flipLock:
		
		if motion.x:
			fliped = motion.x < 0
		else:
			fliped = player.global_position.x < global_position.x
	
	if attackAreaArray and flipArea:
		var direction := (1 - 2 * int(fliped))
		
		for attackPath in attackAreaArray:
			var attack = get_node(attackPath)
			attack.position.x *= sign(attack.position.x) * direction

func _enteredVision(body):
	if body.is_in_group("player"):
		player = body
		emit_signal("enteredVision", body)

func _exitedVision(body):
	if body.is_in_group("player") and not unlimitedVision:
		player = null
		emit_signal("exitedVision", body)


func moveBase(input : int, MotionCord : float, maxSpeed : float = MAXSPEED, ACCEL := ACCELERATION):
	MotionCord += input * ACCEL
	
	if abs(MotionCord) > maxSpeed:
		MotionCord = maxSpeed * sign(MotionCord) 
	
	if sign(MotionCord) != input:
		var saveSign = sign(MotionCord)
		MotionCord -=  DESACCELERATION * saveSign
		if (MotionCord != 0 and sign(MotionCord) != saveSign) and input == 0:
			MotionCord = 0
	
	return MotionCord

func desaccelete(MotionCord, input := 0, desacceleration := DESACCELERATION):
	if sign(MotionCord) != input:
		var saveSign = sign(MotionCord)
		MotionCord -=  desacceleration * saveSign
		if (MotionCord != 0 and sign(MotionCord) != saveSign) and input == 0:
			MotionCord = 0
	
	return MotionCord

func onFloor():
	if !gravity: return true
	return is_on_floor()

func hitted(damage, _area):
	if damage <= 0 or health <= 0:
		return
	modulate = Color(4, 4, 4, 1)
	health -= damage
	
	yield(get_tree().create_timer(0.25), "timeout")
	modulate = Color(1, 1, 1, 1)
	
	if health <= 0:
		emit_signal("defeated", self)
		
