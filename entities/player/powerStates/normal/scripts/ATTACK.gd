extends State

var jumpping := false
var timer := 20

var atkDirection := .0

func enter(_lastState):
	parent.attackComponents[0].monitoring = true
	jumpping = false
	timer = 20
	atkDirection = Input.get_axis("ui_left", "ui_right")
	if atkDirection == 0:
		atkDirection = (1 - (2 * int(parent.fliped)))
	
	parent.fliped = atkDirection < 0
	parent.motion.x = parent.attackVelocity * atkDirection
	parent.motion.y = 0
	parent.playback.travel("ATTACK")
	
func process_state():
	if parent.onWall():
		return "WALL"
	
	if timer <= 0:
		if Input.get_axis("ui_left", "ui_right") != 0 or parent.motion.x != 0:
			
			if Input.is_action_pressed("run"):
				return "TOP_SPEED"
		
			return "RUN"
			
		if parent.canJump and Input.is_action_pressed("ui_jump") and parent.couldUncounch():
			return "JUMP"
		
		elif not parent.onFloor().has(true):
			return "FALL"
		
		elif parent.motion.x == 0 and Input.get_axis("ui_left", "ui_right") == 0 :
			return "IDLE"

	return null
	
func process_physics(delta):
#	if (parent.can_jump and Input.is_action_pressed("ui_jump")) or jumpping:
#		parent.jumpBase()
#		jumpping = true
	parent.motion.x = parent.attackVelocity * atkDirection
	parent.motion.y = 0
	timer -= delta
	if timer <= 0 and not (Input.is_action_pressed("run") and Input.get_axis("ui_left", "ui_right") != 0):
		parent.motion.x /= 2

func exit():
	parent.attackComponents[0].monitoring = false
	parent.canAttackTimer = 0.4
