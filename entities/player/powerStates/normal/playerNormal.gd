extends PlayerBase

enum states {IDLE, RUN, JUMP, FALL}

var currentState : int = states.IDLE

var flyState = preload("res://entities/player/powerStates/flyState/playerFly.tscn").instance()

func _physics_process(_delta):
	_coyoteTimer()
	gravityBase()


	if currentState == states.IDLE:
		if Input.get_axis("ui_left", "ui_right") != 0 or motion.x != 0:
			currentState = states.RUN
	
		elif can_jump and Input.is_action_pressed("ui_jump"):
			currentState = states.JUMP
		
		elif not floorDetect.is_colliding():
			currentState = states.FALL
		
		elif Input.is_action_just_pressed("ui_accept"):
			
			changePowerup(flyState)
	
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
			idleBase()
		states.RUN:
			$Sprite.self_modulate = Color(0, 0.8, 0.4)
			motion.x = moveBase(Input.get_axis("ui_left", "ui_right"), motion.x)
		states.JUMP:
			$Sprite.self_modulate = Color(0.8, 0.2, 0.9)
			jumpBase()
			motion.x = moveBase(Input.get_axis("ui_left", "ui_right"), motion.x)
		states.FALL:
			$Sprite.self_modulate = Color(0, 0.2, 0.9)
			motion.x = moveBase(Input.get_axis("ui_left", "ui_right"), motion.x)
	
	motion = move_and_slide(motion, Vector2.UP)

