extends State

enum  {
	SPLAT,
	WALL
}

var currentState

func enter():
	if parent.motion.y < 0:
		parent.motion.y /= 2
	if not parent.floorDetect.is_colliding():
		parent.playback.travel("SPLAT")
		currentState = SPLAT
	
	elif parent.floorDetect.is_colliding() and abs(parent.motion.x) <= 500:
		parent.playback.travel("WALL")
	parent.running = false

func process_state():
	if Input.get_axis("ui_left", "ui_right") == 0 or not parent.onWall.is_colliding():
		return "IDLE"
	
	elif parent.can_jump and Input.is_action_pressed("ui_jump"):
		return "JUMP"
	
	elif not parent.floorDetect.is_colliding() and not parent.onWall.is_colliding():
		return "FALL"
	
	elif not parent.onWall.is_colliding():
		return "RUN"
	
	return null

func process_physics(_delta):
	parent.motion.x = parent.moveBase("X", parent.motion.x, 350)
	if parent.floorDetect.is_colliding() and parent.playback.get_current_node() != "WALL":
		parent.playback.travel("WALL")
	
