
class_name PlayerBase extends KinematicBody2D

onready var coyoteTimer = $coyoteTimer
onready var onWallRayCast = [$onWallTop, $onWallMid, $onWallBotton]
onready var collideUPCast = $collideUp
onready var shieldTimer = $shieldSystem/shield
onready var animationShield = $shieldSystem/AnimationTree["parameters/playback"]

export var ACCELERATION := 3
export var DESACCELERATION := 10
export var GRAVITY := 10
export var MAXSPEED := 350
export var MAXFALL := 300
export var JUMPFORCE := -400

signal damaged(direction)

var currentState := "IDLE"
var motion := Vector2.ZERO
var canJump := true
var coyote := true
var fliped := false
var stunned := false
var counched := false
var active := true
var shieldActived := false

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

func onWall():
	for ray in onWallRayCast:
		if ray.is_colliding():
			return true
	
	return false


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

func _coyoteTimer():
	if onFloor().has(true):
		canJump = true
		coyote = true
	elif canJump and coyote:
		coyoteTimer.start()
		coyote = false

func onFloor() -> Array:
	return [
		$flooDetectBack.is_colliding(),
		$floorDetect.is_colliding(),
		$flooDetectFont.is_colliding()
	]

func collideUp():
	if collideUPCast.is_colliding():
		var collision = collideUPCast.get_collision_point()
	
		return floor(to_local(collision).y)
	
	return -65

func couldUncounch():
	if counched:
		return collideUp() < -32
	
	return collideUp() < -64 # -32 < -31

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
