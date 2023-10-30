extends PlayerBase

enum states {IDLE, RUN, JUMP, FALL}

var currentState : int = states.IDLE

onready var sprite = $Sprite
onready var animation = $AnimationTree
onready var playback = animation["parameters/playback"]

func _physics_process(_delta):
	_coyoteTimer()
	gravityBase()
	sprite.flip_h = fliped
		
	if currentState == states.IDLE:
		if Input.get_axis("ui_left", "ui_right") != 0 or motion.x != 0:
			currentState = states.RUN
			playback.travel("RUN")
	
		elif can_jump and Input.is_action_pressed("ui_jump"):
			currentState = states.JUMP
		
		elif not floorDetect.is_colliding():
			currentState = states.FALL
		
		elif Input.is_action_just_pressed("ui_accept"):
			
			changePowerup("Fly")
	
	elif currentState == states.RUN:
		if motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0 :
			currentState = states.IDLE
			playback.travel("IDLE")
			
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
				playback.travel("RUN")
				
			else:
				currentState = states.IDLE
				playback.travel("IDLE")
	
	elif currentState == states.FALL:
		if can_jump and Input.is_action_pressed("ui_jump"):
			currentState = states.JUMP
		
		elif floorDetect.is_colliding():
			if Input.get_axis("ui_left", "ui_right") != 0 or motion.x != 0:
				currentState = states.RUN
				playback.travel("RUN")
	
			else:
				currentState = states.IDLE
				playback.travel("IDLE")
	
	animation["parameters/RUN/TimeScale/scale"] = max(0.5, (abs(motion.x) / MAXSPEED) * 3)
	
	match currentState:
		states.IDLE:
			idleBase()
			
		states.RUN:
			motion.x = moveBase(Input.get_axis("ui_left", "ui_right"), motion.x)
			
		states.JUMP:
			jumpBase()
			motion.x = moveBase(Input.get_axis("ui_left", "ui_right"), motion.x)
			
		states.FALL:
			motion.x = moveBase(Input.get_axis("ui_left", "ui_right"), motion.x)
			
	
	motion = move_and_slide(motion, Vector2.UP)
