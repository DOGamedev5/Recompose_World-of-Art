tool

class_name PlayerBase extends KinematicBody2D

onready var coyoteTimer = $coyoteTimer
onready var floorDetect = $floorDetect

export var ACCELERATION := 3
export var DESACCELERATION := 10
export var GRAVITY := 10
export var MAXSPEED := 350
export var MAXFALL := 300
export var JUMPFORCE := -400

var motion := Vector2.ZERO
var can_jump := true
var coyote := true
var fliped := false

var powers := {
	"Normal" : "res://entities/player/powerStates/normal/playerNormal.tscn",
	"Fly" : "res://entities/player/powerStates/fly/playerFly.tscn"
}

func _physics_process(_delta):
	if Input.get_axis("ui_left", "ui_right") != 0:
		fliped = Input.get_axis("ui_left", "ui_right") < 0

func gravityBase():
	if not floorDetect.is_colliding():
		motion.y += GRAVITY
		if motion.y > MAXFALL:
			motion.y = MAXFALL

func changePowerup(powerUp):
	var newPlayer = load(powers[powerUp]).instance()
	get_parent().add_child(newPlayer)
	newPlayer.global_position = global_position
	queue_free()

func idleBase():
	if motion.x > 0:
		motion.x -= DESACCELERATION
		if motion.x < 0:
			motion.x = 0
	
	elif motion.x < 0:
		motion.x += DESACCELERATION
		if motion.x > 0: 
			motion.x = 0

func moveBase(inputAxis : float, MotionCord : float):
	
	if MotionCord > 0 and inputAxis <= 0:
		MotionCord -= DESACCELERATION
		if MotionCord < 0 and inputAxis == 0:
			MotionCord = 0
	
	elif MotionCord < 0 and inputAxis >= 0:
		MotionCord += DESACCELERATION
		if MotionCord > 0 and inputAxis == 0:
			MotionCord = 0
	
	if inputAxis:
		MotionCord += ACCELERATION * inputAxis
		if abs(MotionCord) > MAXSPEED:
			MotionCord = MAXSPEED * inputAxis
	
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
