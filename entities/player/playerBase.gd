
class_name PlayerBase extends KinematicBody2D

onready var coyoteTimer := $coyoteTimer
onready var jumpBufferTimer := $jumpBuffer
onready var onWallRayCast := [$onWallTop, $onWallMid, $onWallDown]
onready var collideUPCast = [$collideUpBack, $collideUp, $collideUpFront]
onready var shieldTimer = $shieldSystem/shield
onready var animationShield = $shieldSystem/AnimationTree["parameters/playback"]
onready var transition = $"../HUD".get_node("transition")
onready var HUD = $"../HUD"
onready var camera = $Camera2D

const SNAPLENGTH := 32

export(NodePath) var stateMachinePath
var stateMachine : StateMachine

export(Array) var particles
export(Array) var FlipObjects

export var gravity := true
export var ACCELERATION := 3
export var DESACCELERATION := 10
export var GRAVITY := 10
export var MAXSPEED := 350
export var MAXFALL := 300
export var JUMPFORCE := -400
export var MAXHEALTH := 400
 
signal damaged(direction)

var enteredObjects := []

var motion := Vector2.ZERO
var realMotion := Vector2.ZERO
var lastPosition := Vector2.ZERO
var cinematic := false

var jumpBuffer := false
var jumpReleased := false
var canJump := true
var coyote := true
var fliped := false
var stunned := false
var counched := false
var active := true
var moving := true
var shieldActived := false
var currentSnapLength := .0
var snapDesatived := false
var canLadder := false

var health = MAXHEALTH

var inputCord := {
	"X" : ["ui_left", "ui_right"],
	"Y" : ["ui_up", "ui_down"]
}

var powers := {
	"Normal" : "res://entities/player/powerStates/normal/playerNormal.tscn",
	"Fly" : "res://entities/player/powerStates/fly/playerFly.tscn"
}

func _ready():
	Global.player = self
	$"../HUD".call_deferred("init")
#	if Global.world.currentRoom:
#		setCameraLimits(Global.world.currentRoom.limitsMin, Global.world.currentRoom.limitsMax)
	
	lastPosition = position
	if stateMachinePath: 
		stateMachine = get_node(stateMachinePath)
		stateMachine.init(self)

func physics_process(delta):
	if not moving:
		motion.x = 0
	
	realMotion = ((position - lastPosition) * Engine.get_frames_per_second())
	set_deferred("lastPosition", position)
	
	if gravity:
		gravityBase()
	
	if cinematic: return
	
	if not stunned and moving:
		
		if collideUp() > -34 or (Input.is_action_pressed("ui_down") and not cinematic):
			counched = true
		else:
			counched = false
			
		
		if motion.x != 0:
			fliped = motion.x < 0
		elif Input.get_axis("ui_left", "ui_right") and not cinematic:
			fliped = Input.get_axis("ui_left", "ui_right") < 0
			
		for ray in onWallRayCast: 
			if motion.x:
				ray.cast_to.x = 28 * sign(motion.x)
			else:
				ray.cast_to.x = 28 * Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("ui_jump"):
		jumpBuffer = true
		jumpReleased = false
		jumpBufferTimer.start()
	
	if not active: return
	
	if stateMachine:
		stateMachine.processMachine(delta)

func setParticle(index := 0, emitting := true):
	var particle = get_node(particles[index])
	
	particle.emitting = emitting

func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	camera.set("limit_left", limitsMin.x - 10)
	camera.set("limit_top", limitsMin.y - 10)
	camera.set("limit_right", limitsMax.x + 10)
	camera.set("limit_bottom", limitsMax.y + 10)

func flipObject(objects):
	for obj in objects:
		obj.position.x = obj.position.x * (1 - 2 * int(fliped)) * sign(obj.position.x)

func resetParticles():
	if not particles: return
	
	for obj in particles:
		var node = get_node(obj)
		if node is CPUParticles2D or node is Particles2D:
			var emitting = node.emitting
			node.restart()
			
			node.emitting = emitting
		else:
			push_warning("warning: " + node.name + " its not a CPUParticles2D or Particles2D")
			

func gravityBase():
	if not onFloor():
		
		motion.y += GRAVITY
		if motion.y > MAXFALL:
			motion.y = MAXFALL
	

func init(powerUp := "Normal"):
	var newPlayer = load(powers[powerUp]).instance()

	return newPlayer

func changePowerup(powerUp):
	Global.changePlayer(powerUp)

func idleBase():
	var isOnFloor = is_on_floor()
	var isOnSlope = get_floor_normal().x != 0
	
	if isOnFloor and isOnSlope and !snapDesatived and motion.x == 0:
		motion.y = 0
	motion.x = desaccelerate(motion.x)

func moveBase(inputAxis : String, MotionCord : float, maxSpeed : float = MAXSPEED):
	var input := Input.get_axis(inputCord[inputAxis][0], inputCord[inputAxis][1])
	if cinematic:
		input = 0

	MotionCord = desaccelerate(MotionCord, input)
	
	if not moving: return
	
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

func _move_and_slide(snap, stopSlope):
	motion.y = move_and_slide_with_snap(motion, Vector2.DOWN*snap, Vector2.UP, stopSlope, 4, deg2rad(46)).y

func move(stopSlope = true):
	var snap := Vector2.ZERO
	if not snapDesatived:
		
		snap = Vector2.DOWN * SNAPLENGTH

	motion.y = move_and_slide_with_snap(motion, Vector2.DOWN*snap, Vector2.UP, stopSlope, 4, deg2rad(46)).y
#	call_deferred("_move_and_slide", snap, stopSlope)
	
	if abs(realMotion.x) < 1 and abs(motion.x) > 100 and onWall():
		motion.x = 0   
	currentSnapLength = snap.y
	
	if onFloor() and motion.y != 0 and not Input.is_action_pressed("ui_jump") and not onSlope() and !snapDesatived:
		motion.y = 0

func desaccelerate(MotionCord : float, input := .0):
	if sign(MotionCord) != input:
		var saveSign = sign(MotionCord)
		MotionCord -=  DESACCELERATION * saveSign
		if (MotionCord != 0 and sign(MotionCord) != saveSign) and input == 0:
			MotionCord = 0
	
	return MotionCord

func jumpBase(force = JUMPFORCE):
	if canJump and couldUncounch():
		snapDesatived = true
		motion.y = force
		coyote = false
		canJump = false
		
	elif not Input.is_action_pressed("ui_jump") and not jumpReleased:
		motion.y /= 2
		jumpReleased = true
		snapDesatived = false

func _coyoteTimer():
	if onFloor()  and gravity:
		canJump = true if collideUp() == -65 else false
		coyote = true
	elif canJump and coyote:
		coyoteTimer.start()
		coyote = false

func onFloor():
	if !gravity: return true
	return is_on_floor()
	
func onSlope():
	
	return is_on_floor() and  get_floor_normal().x != 0


func getSlopeNormal():
	var normal := Vector2.UP
	if $slopeDetect.is_colliding():
		normal = $slopeDetect.get_collision_normal()
	
	return normal

func onWall():
	var distance := 28
	var rayDirection
	
	for ray in onWallRayCast:
		if !ray.is_colliding(): continue
		
		var normal = ray.get_collision_normal()
		
		if abs(normal.y) > 0.5: continue
		
		var point = abs(to_local(ray.get_collision_point()).x)
		
		if point < distance:
			distance = point
		
		rayDirection = sign(ray.cast_to.x)
	
	var result = distance < 16.8 and distance >= 15
	
	if result and  rayDirection != Input.get_axis("ui_left", "ui_right") and active:
		if Input.get_axis("ui_left", "ui_right") != 0 and motion.x:
			
			motion.x = 0
			return true
		
	if result:
		if rayDirection == sign(motion.x):
			
			motion.x = 0
			
		global_position.x += (distance - 16) * rayDirection
		return true

	return false

func collideUp():
	var collision := -65.0
	
	for ray in collideUPCast:
		if ray.is_colliding():
			var collisionPoint = ray.get_collision_point()
	
			if floor(to_local(collisionPoint).y) < -29.0 and floor(to_local(collisionPoint).y) > collision:
				collision = floor(to_local(collisionPoint).y)
	
	return collision

func couldUncounch(counch = counched):
	if counch:
		return collideUp() < -33
	
	return collideUp() < -64

func shield():
	shieldTimer.start()
	animationShield.travel("shield")

func setCinematic(value : bool):
	cinematic = value
	moving = not value
	if value:
		Global.playerHud.cinematic.actived()
		motion.x = 0
		if motion.y < 0:
			motion.y /= 2
	
		stateMachine.changeState("IDLE")
	
	else:
		Global.playerHud.cinematic.desactivaded()

func coyoteTimerTimeout():
	canJump = false

func hitboxTriggered(damage : DamageAttack):
	if not ("enemy" in damage.objectGroup and not shieldActived):
		return

	var direction : int = damage.direction.x
	emit_signal("damaged", direction)
	health -= damage.damage
	HUD.setHealth(health)
	shieldActived = true
		
func _on_HitboxComponent_area_entered(area):
	if area is ChangeRoom and active:
		active = false
		$HitboxComponent.set_deferred("monitoring", false)
		area.changeRoom()
		
	elif area.is_in_group("ladder"):
		enteredObjects.append(area)
		canLadder = true
	
	elif area.is_in_group("enemyVision"):
		area.get_parent().player = self

func hitboxExited(area):
	if area.is_in_group("enemyVision"):
		if area.get_parent().canUnwatch:
			area.get_parent().player = null
	
	elif area.is_in_group("ladder"):
		enteredObjects.erase(area)
	
	var onLadder := false

	for obj in enteredObjects:
		if obj.is_in_group("ladder"):
			onLadder = true
			break
	
	canLadder = onLadder
	

func shieldTimeout():
	animationShield.travel("RESET")
	shieldActived = false

func _on_jumpBuffer_timeout():
	jumpBuffer = false


