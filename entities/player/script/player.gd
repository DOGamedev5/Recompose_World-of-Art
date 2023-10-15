extends KinematicBody2D

onready var coyoteTimer = $coyoteTimer
onready var floorDetect = $floorDetect

const ACCELERATION := 3
const DESACCELERATION := 10
const GRAVITY := 10
const MAXSPEED := 350
const MAXFALL := 300
const JUMPFORCE := -400


enum states {IDLE, RUN, JUMP, FALL}

var currentState : int = states.IDLE

var motion := Vector2.ZERO
var can_jump := true
var coyote := true


func _physics_process(_delta):
	
	_coyoteTimer()
	
	if not floorDetect.is_colliding():
		motion.y += GRAVITY
		if motion.y > MAXFALL:
			motion.y = MAXFALL


	if currentState == states.IDLE:
		if Input.get_axis("ui_left", "ui_right") != 0 or motion.x != 0:
			currentState = states.RUN
	
		elif can_jump and Input.is_action_pressed("ui_jump"):
			currentState = states.JUMP
		
		elif not floorDetect.is_colliding():
			currentState = states.FALL
	
	elif currentState == states.RUN:
		if motion.x == 0 :
			currentState = states.IDLE
			
		elif can_jump and Input.is_action_pressed("ui_jump"):
			currentState = states.JUMP
		
		elif not floorDetect.is_colliding():
			currentState = states.FALL
				
	elif  currentState == states.JUMP:
		if motion.y > 0:
			currentState = states.FALL
		
		elif floorDetect.is_colliding():
			if Input.get_axis("ui_left", "ui_right") != 0 or motion.x != 0:
				currentState = states.RUN
			else:
				currentState = states.IDLE
	
	elif currentState == states.FALL:
		if can_jump and Input.is_action_pressed("ui_jump"):
			currentState = states.JUMP
		
		elif floorDetect.is_colliding():
			if Input.get_axis("ui_left", "ui_right") != 0 or motion.x != 0:
				currentState = states.RUN
			else:
				currentState = states.IDLE
	
	match currentState:
		states.IDLE:
			$Sprite.self_modulate = Color(0.8, 0.2, 0.4)
			idle()
		states.RUN:
			$Sprite.self_modulate = Color(0, 0.8, 0.4)
			run()
		states.JUMP:
			$Sprite.self_modulate = Color(0.8, 0.2, 0.9)
			jump()
			run()
		states.FALL:
			$Sprite.self_modulate = Color(0, 0.2, 0.9)
			run()
	
	motion = move_and_slide(motion, Vector2.UP)

func idle():
	if motion.x > 0:
		motion.x -= DESACCELERATION
		if motion.x < 0:
			motion.x = 0
	
	elif motion.x < 0:
		motion.x += DESACCELERATION
		if motion.x > 0: 
			motion.x = 0

func run():
	var input := Input.get_axis("ui_left", "ui_right")
	
	if motion.x > 0 and input <= 0:
		motion.x -= DESACCELERATION
		if motion.x < 0 and input == 0:
			motion.x = 0
	
	elif motion.x < 0 and input >= 0:
		motion.x += DESACCELERATION
		if motion.x > 0 and input == 0:
			motion.x = 0
	
	if input:

		motion.x += ACCELERATION * input
		
		if abs(motion.x) > MAXSPEED:
			motion.x = MAXSPEED * input

func jump():
	
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

func _on_coyoteTimer_timeout():
	can_jump = false

