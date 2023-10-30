extends PlayerBase

enum states {IDLE, FLY}

var currentState : int = states.IDLE


func _physics_process(_delta):
	
	if currentState == states.IDLE:
		var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		if input:
			currentState = states.FLY
		
		elif Input.is_action_just_pressed("ui_accept"):
			changePowerup("Normal")
	
	elif currentState == states.FLY:
		var input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		if not input and motion == Vector2.ZERO:
			currentState = states.IDLE
		
		elif Input.is_action_just_pressed("ui_accept"):
			changePowerup("Normal")
	
	match currentState:
		states.IDLE:
			pass
		
		states.FLY:
			var input := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis( "ui_up", "ui_down"))
			
			motion = Vector2(moveBase(input.x, motion.x), moveBase(input.y, motion.y))
			
			
		
	motion = move_and_slide(motion)
