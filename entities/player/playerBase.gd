
class_name PlayerBase extends KinematicBody2D

onready var coyoteTimer = $coyoteTimer
onready var floorDetect = $floorDetect

export var ACCELERATION := 3
export var DESACCELERATION := 10
export var GRAVITY := 10
export var MAXSPEED := 350
export var MAXFALL := 300
export var JUMPFORCE := -400

var currentState := "IDLE"
var motion := Vector2.ZERO
var can_jump := true
var coyote := true
var fliped := false
var stunned := false

var powers := {
	"Normal" : "res://entities/player/powerStates/normal/playerNormal.tscn",
	"Fly" : "res://entities/player/powerStates/fly/playerFly.tscn"
}

var inputCord := {
	"X" : ["ui_left", "ui_right"],
	"Y" : ["ui_up", "ui_down"]
}

func _physics_process(_delta):
	if motion.x != 0:
		fliped = motion.x < 0
		 

func gravityBase():
	if not floorDetect.is_colliding():
		motion.y += GRAVITY
		if motion.y > MAXFALL:
			motion.y = MAXFALL

func init(powerUp := "Normal"):
	var newPlayer = load(powers[powerUp]).instance()
	newPlayer.resourceInit(Global.player)
	return newPlayer

func changePowerup(powerUp):
	Global.emit_signal("playerFormChange", powerUp)
	var newPlayer = load(powers[powerUp]).instance()
	get_parent().add_child(newPlayer)
	newPlayer.global_position = global_position
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
	
	return MotionCord

func desaccelerate(MotionCord : float, input := .0):
	if sign(MotionCord) != input:
		var saveSign = sign(MotionCord)
		MotionCord -=  DESACCELERATION * saveSign
		if (MotionCord != 0 and sign(MotionCord) != saveSign) and input == 0:
			MotionCord = 0
	
	return MotionCord

func jumpBase():
	
	if can_jump:
		motion.y = JUMPFORCE
		coyote = false
		can_jump = false
	elif Input.is_action_just_released("ui_jump"):
		motion.y /= 2

func _coyoteTimer():
	if floorDetect.is_colliding():
		can_jump = true
		coyote = true
	elif can_jump and coyote:
		coyoteTimer.start()
		coyote = false

func coyoteTimerTimeout():
	can_jump = false

func syncValues():
	pass
