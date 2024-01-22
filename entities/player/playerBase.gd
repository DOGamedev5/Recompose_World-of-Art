
class_name PlayerBase extends KinematicBody2D

onready var coyoteTimer = $coyoteTimer
onready var onWallRayCast = [$onWallTop, $onWallMid]
onready var collideUPCast = $collideUp
onready var shieldTimer = $shieldSystem/shield
onready var animationShield = $shieldSystem/AnimationTree["parameters/playback"]

const SNAPLENGTH := 64

export(NodePath) var stateMachinePath
var stateMachine

export var gravity := true

export var ACCELERATION := 3
export var DESACCELERATION := 10
export var GRAVITY := 10
export var MAXSPEED := 350
export var MAXFALL := 300
export var JUMPFORCE := -400

signal damaged(direction)

var motion := Vector2.ZERO
var canJump := true
var coyote := true
var fliped := false
var stunned := false
var counched := false
var active := true
var shieldActived := false
var currentSnapLength := 0
var snapDesatived := false
var canLadder := false


var powers := {
	"Normal" : "res://entities/player/powerStates/normal/playerNormal.tscn",
	"Fly" : "res://entities/player/powerStates/fly/playerFly.tscn"
}

var inputCord := {
	"X" : ["ui_left", "ui_right"],
	"Y" : ["ui_up", "ui_down"]
}

func _ready():
	if stateMachinePath: 
		stateMachine = get_node(stateMachinePath)
		stateMachine.init(self)



func _physics_process(delta):
	if not stunned:
		
		if collideUp() > -34 or Input.is_action_pressed("ui_down"):
			counched = true
		else:
			counched = false
		
		if motion.x != 0:
			fliped = motion.x < 0
		elif Input.get_axis("ui_left", "ui_right"):
			fliped = Input.get_axis("ui_left", "ui_right") < 0
			
		for ray in onWallRayCast: 
			if motion.x:
				ray.cast_to.x = 28 * sign(motion.x)
			else:
				ray.cast_to.x = 28 * Input.get_axis("ui_left", "ui_right")
	
	if not active: return
	
	if stateMachine:
		stateMachine.processMachine(delta)
	
	if gravity:
		gravityBase()
	


func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	$Camera2D.set("limit_left", limitsMin.x - 10)
	$Camera2D.set("limit_top", limitsMin.y - 10)
	$Camera2D.set("limit_right", limitsMax.x + 10)
	$Camera2D.set("limit_bottom", limitsMax.y + 10)

func gravityBase():
	if not onFloor().has(true):
		
		motion.y += GRAVITY
		if motion.y > MAXFALL:
			motion.y = MAXFALL
	

func init(powerUp := "Normal"):
	var newPlayer = load(powers[powerUp]).instance()

	return newPlayer

func changePowerup(powerUp):
	
	var newPlayer = load(powers[powerUp]).instance()
	get_parent().add_child(newPlayer)
	newPlayer.global_position = global_position
	get_parent().player = newPlayer
	queue_free()

func idleBase():
	motion.x = desaccelerate(motion.x)

func moveBase(inputAxis : String, MotionCord : float, maxSpeed : float = MAXSPEED):
	var input := Input.get_axis(inputCord[inputAxis][0], inputCord[inputAxis][1])

	MotionCord = desaccelerate(MotionCord, input)
	
	
	if input > 0:
		if MotionCord <= maxSpeed:
			MotionCord += ACCELERATION
		else:
			MotionCord -= DESACCELERATION

	elif input < 0:
		if MotionCord >= -maxSpeed:
			MotionCord -= ACCELERATION
		else:
			MotionCord += DESACCELERATION
	
	if inputAxis == "X":
		motion.x = MotionCord
	else:
		motion.y = MotionCord

func move(stopSlope = true):
	var snap := Vector2.ZERO
	if not snapDesatived:
		
		snap = Vector2.DOWN*SNAPLENGTH

	motion.y = move_and_slide_with_snap(motion, Vector2.DOWN*snap, Vector2.UP, true, 4, deg2rad(46)).y
	
	
	if onFloor().has(true) and motion.y != 0 and not Input.is_action_pressed("ui_jump") and not onSlope() and !snapDesatived:
		motion.y = 0
		
	

func desaccelerate(MotionCord : float, input := .0):
	if sign(MotionCord) != input:
		var saveSign = sign(MotionCord)
		MotionCord -=  DESACCELERATION * saveSign
		if (MotionCord != 0 and sign(MotionCord) != saveSign) and input == 0:
			MotionCord = 0
	
	return MotionCord

func jumpBase(force = JUMPFORCE):
	
	
	if canJump and couldUncounch():
		snapDesatived = true
		motion.y = force
		coyote = false
		canJump = false
		
	elif Input.is_action_just_released("ui_jump"):
		motion.y /= 2
		snapDesatived = false

func _coyoteTimer():
	if onFloor().has(true):
		canJump = true
		coyote = true
	elif canJump and coyote:
		coyoteTimer.start()
		coyote = false

func onFloor():
	if !gravity: return [false, false, false]
	var raycasts = [
		$flooDetectBack,
		$floorDetect,
		$flooDetectFont
	]
	
	var leviting := 24
	
	for i in range(3):
		var ray = raycasts[i]
		if !ray.is_colliding(): continue
		
		var point = to_local(ray.get_collision_point()).y
		
		if point < leviting:
			leviting = point
	
#	print(leviting)
	var result = leviting <= 8 
	
	if result: global_position.y += leviting
	
	if $slopeDetect.is_colliding() and onSlope():
#		global_position.y += -8
		return [true, true, true]
	return [result, result, result]
	

func onSlope():
	var normalAngle
	var normal
	var isOnSlope
	if $slopeDetect.is_colliding():
		normal = $slopeDetect.get_collision_normal()
		normalAngle = normal.angle()
		
		isOnSlope = !(abs(rad2deg(normalAngle)) >= 85 and abs(rad2deg(normalAngle)) <= 95)
		
	else:
		isOnSlope = false
		
	return isOnSlope

func getSlopeNormal():
	var normal := Vector2.UP
	if $slopeDetect.is_colliding():
		normal = $slopeDetect.get_collision_normal()
	
	return normal

func onWall():
	var distance := 28
	var rayDirection
	
	for ray in onWallRayCast:
		if !ray.is_colliding(): continue
		
		var point = abs(to_local(ray.get_collision_point()).x)
		
		if point < distance:
			distance = point
		
		rayDirection = sign(ray.cast_to.x)
	
	
	var result = distance < 16.8 and distance >= 16
	
	if result and  rayDirection != Input.get_axis("ui_left", "ui_right"):
		if Input.get_axis("ui_left", "ui_right") != 0 and motion.x:
			motion.x = 0
		
	
	if result:
		if rayDirection == sign(motion.x):
			motion.x = 0
			
		global_position.x += (distance - 16) * rayDirection
		return true

	return false


func collideUp():
	if collideUPCast.is_colliding():
		var collision = collideUPCast.get_collision_point()
	
		return floor(to_local(collision).y)
	
	return -65

func couldUncounch(counch = counched):
	if counch:
		return collideUp() < -33
	
	return collideUp() < -64

func shield():
	shieldTimer.start()
	animationShield.travel("shield")

func coyoteTimerTimeout():
	canJump = false

func hitboxTriggered(_damage, area):
	if not active: return
	
	if area is ChangeRoom:
		area.changeRoom()

	elif area is AttackComponent and area.is_in_group("enemy") and not shieldActived:
		var direction := sign(area.global_position.x - position.x)
		emit_signal("damaged", direction)
		shieldActived = true
	
	elif area.is_in_group("ladder"):
		canLadder = true	
		
func hitboxExited(area):
	if area.is_in_group("ladder"):
		canLadder = false

func shieldTimeout():
	animationShield.travel("RESET")

	shieldActived = false
