extends KinematicBody2D

onready var coyoteTimer = $coyoteTimer

const ACCELERATION := 3
const DESACCELERATION := 10
const GRAVITY := 10
const MAXSPEED := 350
const MAXFALL := 300
const JUMPFORCE := -300

var motion := Vector2.ZERO

var can_jump := true
var coyote := true


func _physics_process(delta):
	var input := Input.get_axis("ui_left", "ui_right")
	
	if input:
		desacellete(input)
		
		motion.x += ACCELERATION * input
		
		if abs(motion.x) > MAXSPEED:
			motion.x = MAXSPEED * input
		
	else:
		desacellete()
	
	if is_on_floor():
		can_jump = true
	elif can_jump and coyote:
		coyoteTimer.start()
		coyote = false
	
	if can_jump and Input.is_action_pressed("ui_jump"):
		motion.y = JUMPFORCE
	elif Input.is_action_just_released("ui_jump"):
		motion.y /= 2
	
	if not is_on_floor():
		motion.y += GRAVITY
		if motion.y > MAXFALL:
			motion.y = MAXFALL
	
	if abs(motion.x) >= 300:
		$Sprite.self_modulate = Color(0.9, 0.2, 0.5)
	elif  abs(motion.x) >= 200:
		$Sprite.self_modulate = Color(0.5, 0.2, 0.4)
	elif  abs(motion.x) >= 100:
		$Sprite.self_modulate = Color(0.2, 0.9, 0.4)
	else:
		$Sprite.self_modulate = Color(0.4, 0.8, 1)
	
	motion = move_and_slide(motion, Vector2.UP)


func desacellete(input := 0):
	if motion.x > 0 and input <= 0:
		motion.x -= DESACCELERATION
		if motion.x < 0 and input == 0:
			motion.x = 0
	
	elif motion.x < 0 and input >= 0:
		motion.x += DESACCELERATION
		if motion.x > 0 and input == 0:
			motion.x = 0

func _on_coyoteTimer_timeout():
	can_jump = false
	coyote = true
