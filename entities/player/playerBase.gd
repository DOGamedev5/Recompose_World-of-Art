
class_name PlayerBase extends KinematicBody2D

onready var coyoteTimer = $coyoteTimer
onready var onWallRayCast = [$onWallTop, $onWallMid]
onready var collideUPCast = $collideUp
onready var shieldTimer = $shieldSystem/shield
onready var animationShield = $shieldSystem/AnimationTree["parameters/playback"]

const SNAPLENGTH := 32

export var ACCELERATION := 3
export var DESACCELERATION := 10
export var GRAVITY := 10
export var MAXSPEED := 350
export var MAXFALL := 300
export var JUMPFORCE := -400

signal damaged(direction)

var currentState := "IDLE"
var motion := Vector2.ZERO
var velocity := Vector2.ZERO
var canJump := true
var coyote := true
var fliped := false
var stunned := false
var counched := false
var active := true
var shieldActived := false
var currentSnapLength := 0
var snapDesatived := false

var perpendicular = Vector2.RIGHT


var powers := {
	"Normal" : "res://entities/player/powerStates/normal/playerNormal.tscn",
	"Fly" : "res://entities/player/powerStates/fly/playerFly.tscn"
}

var inputCord := {
	"X" : ["ui_left", "ui_right"],
	"Y" : ["ui_up", "ui_down"]
}

func _physics_process(_delta):
	if not stunned:
		if collideUp() > -33 or Input.is_action_pressed("ui_down"):
			counched = true
		else:
			counched = false
		
		if motion.x != 0:
			fliped = motion.x < 0
		elif Input.get_axis("ui_left", "ui_right"):
			fliped = Input.get_axis("ui_left", "ui_right") < 0
			
		for ray in onWallRayCast: 
			ray.cast_to.x = 28 * Input.get_axis("ui_left", "ui_right")
#		$slopeDetect.position.x = 8 * Input.get_axis("ui_left", "ui_right")
		
					 
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
	elif currentSnapLength == SNAPLENGTH and motion.y != 0  and (!onSlope()[0] or motion.x == 0) and !snapDesatived:
		motion.y = 0

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
#	motion.y = move_and_slide(motion, Vector2.UP, stopSlope, 4, deg2rad(46)).y
	var snap := Vector2.ZERO
	if not snapDesatived: 
		snap = Vector2.DOWN*currentSnapLength 

	motion.y = move_and_slide_with_snap(motion, Vector2.DOWN*snap, Vector2.UP, true, 4, deg2rad(46)).y
	
	if onFloor().has(true) and motion.y >= 0 and currentSnapLength == 0 and not Input.is_action_pressed("ui_jump"):
		currentSnapLength = SNAPLENGTH
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
	
	var raycasts = [
		$flooDetectBack,
		$floorDetect,
		$flooDetectFont
	]

	if $slopeDetect.is_colliding() and onSlope()[0]: return [true, true, true]
	
	var leviting := 8
	for ray in raycasts:
		if !ray.is_colliding(): continue
		
		var point = to_local(ray.get_collision_point())
		
		if point.y < leviting:
			leviting = point.y
	
	var result = leviting < 0.5
	if result:
		global_position.y += leviting
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
		
	return [isOnSlope, normal]

func onWall():
	var distance := 28
	var rayDirection
	
	for ray in onWallRayCast:
		if !ray.is_colliding(): continue
		var point = abs(to_local(ray.get_collision_point()).x)
		
		if point < distance:
			distance = point
		
		rayDirection = sign(ray.cast_to.x)
		
		
#			if motion.x != 0: motion.x = 0
	var result = distance < 16.8 and distance >= 16
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
		return collideUp() < -32
	
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
		
func shieldTimeout():
	animationShield.travel("RESET")

	shieldActived = false
