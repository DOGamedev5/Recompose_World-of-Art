
class_name PlayerBase extends EntityBase
onready var coyoteTimer := $coyoteTimer
onready var jumpBufferTimer := $jumpBuffer
onready var onWallRayCast := [$onWallTop, $onWallMid, $onWallDown]
onready var insideDetect := [$insideDetectLeft, $insideDetectRight, $insideDetectLeft2, $insideDetectRight2]
onready var collideUPCast := [$collideUpBack, $collideUp, $collideUpFront]
onready var shieldTimer := $shieldSystem/shield
onready var animationShield : AnimationNodeStateMachinePlayback = $shieldSystem/AnimationTree["parameters/playback"]
onready var camera := $Camera2D
onready var listener := $Listener2D
onready var hitbox := $HitboxComponent

const SNAPLENGTH := 32

export(NodePath) var spriteGizmoPath : NodePath
onready var spriteGizmo : Node2D = get_node_or_null(spriteGizmoPath)

export(Array) var particles
export(Array) var FlipObjects

export(String, DIR) var spritesPath := "res://entities/player/powerStates/"

signal damaged(direction)

var enteredObjects := []

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
var lockRotate := false

var health = MAXHEALTH

const inputCord := {
	"X" : ["ui_left", "ui_right"],
	"Y" : ["ui_up", "ui_down"]
}

func _ready():
	if Network.is_owned(OwnerID):
		var timer = Timer.new()
		timer.wait_time = 0.05
		timer.connect("timeout", self, "_networkUpdate")
		add_child(timer)
		timer.start()
	
	if Network.is_owned(OwnerID):
		listener.current = true
		camera.current = true
	
	var hud := get_node_or_null("../HUD")
	if hud: hud.call_deferred("init", self)
	else: print("there's no hud!")
	
	lastPosition = position
	
	if stateMachine: stateMachine.init(self)

func physics_process(delta):
	
	realMotion = ((position - lastPosition) * Engine.get_frames_per_second())
	set_deferred("lastPosition", position)
	
	detectInside()
	
	if not moving:
		motion.x = 0
	
	if gravity:
		gravityBase()
	
	if cinematic: return
	
	if not stunned and moving:
		
		if collideUp() > -34 or (Global.handInput("ui_down", true, OwnerID) and not cinematic):
			counched = true
		else:
			counched = false
			
		
		if motion.x != 0:
			fliped = motion.x < 0
		elif Global.handInputAxis("ui_left", "ui_right", OwnerID) and not cinematic:
			fliped = Global.handInputAxis("ui_left", "ui_right", OwnerID) < 0
		
		if Network.is_owned(OwnerID):
			for ray in onWallRayCast: 
				if motion.x:
					ray.cast_to.x = 28 * sign(motion.x)
				else:
					ray.cast_to.x = 28 * Global.handInputAxis("ui_left", "ui_right", OwnerID)
	
	if Global.handInput("ui_jump", OwnerID):
		jumpBuffer = true
		jumpReleased = false
		jumpBufferTimer.start()
	
	if not active: return
	
	if stateMachine:
		stateMachine.processMachine(delta)



func detectInside():
	var normalMin := 0.8
	
	if not $rayShapeLeft.disabled:
		if insideDetect[2].is_colliding():
			$rayShapeLeft.disabled = (not abs(insideDetect[2].get_collision_normal().x) >= normalMin) and $slopeDetect.is_colliding()

		else:
			$rayShapeLeft.disabled = true
	else:
		if insideDetect[0].is_colliding():
			$rayShapeLeft.disabled = (not abs(insideDetect[0].get_collision_normal().x) >= normalMin) and $slopeDetect.is_colliding()

		else:
			$rayShapeLeft.disabled = true
	
	if not $rayShapeRight.disabled:
		if insideDetect[3].is_colliding():
			$rayShapeRight.disabled = (not abs(insideDetect[3].get_collision_normal().x) >= normalMin) and $slopeDetect.is_colliding()
		else:
			$rayShapeRight.disabled = true
	else:
		if insideDetect[1].is_colliding():
			$rayShapeRight.disabled = (not abs(insideDetect[1].get_collision_normal().x) >= normalMin) and $slopeDetect.is_colliding()
		else:
			$rayShapeRight.disabled = true
	

func rotateNormal(_delta):
	var floorNormal : Vector2 = getSlopeNormal()
	
	if not onFloor():
		floorNormal.x = clamp((motion.x / (MAXSPEED)), -0.2, 0.2)
		floorNormal.y = -(1 - abs(floorNormal.x))
		if motion.y > 0: floorNormal.x *= -1
	
	return floorNormal

func rotateSprite(delta):
	if not spriteGizmo: return
	
	if lockRotate:
		$sprite.rotation = 0
		return
	
	var floorNormal : Vector2 = rotateNormal(delta)
	var weight := 20
	
	if not onFloor():
		weight = 10
	
	var angle : float = max(min(atan2(float(floorNormal.x), -float(floorNormal.y)), deg2rad(45)), deg2rad(-45))
	
	$sprite.rotation = lerp_angle($sprite.rotation, angle, weight * delta)

func setParticle(index := 0, emitting := true):
	var particle = get_node(particles[index])
	
	particle.emitting = emitting

func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	if not Network.is_owned(OwnerID): return
	camera.set("limit_left", limitsMin.x - 10)
	camera.set("limit_top", limitsMin.y - 10)
	camera.set("limit_right", limitsMax.x + 10)
	camera.set("limit_bottom", limitsMax.y + 10)

func setCinematic(value : bool):
	if not Network.is_owned(OwnerID): return	
	Global.inputEnabled = not value
	if value:
		$"../HUD".cinematic.actived()
		motion.x = 0
		if motion.y < 0: motion.y /= 2
	
		stateMachine.changeState("IDLE")
	
	else:
		$"../HUD".cinematic.desactivaded()

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

func idleBase():
	var isOnFloor = is_on_floor()
	var isOnSlope = get_floor_normal().x != 0
	
	if isOnFloor and isOnSlope and !snapDesatived and motion.x == 0:
		motion.y = 0
	motion.x = desaccelerate(motion.x)

func moveBase(inputAxis : String, MotionCord : float, maxSpeed : float = MAXSPEED):
	if not Network.is_owned(OwnerID): return
	var input := sign(Global.handInputAxis(inputCord[inputAxis][0], inputCord[inputAxis][1], OwnerID))
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

func move():
	var snap := Vector2.ZERO
	if not snapDesatived:
		
		snap = Vector2.DOWN * SNAPLENGTH

	if motion: detectInside()	
	
	motion = move_and_slide_with_snap(motion, Vector2.DOWN*snap, Vector2.UP, true) 
	currentSnapLength = snap.y

func desaccelerate(MotionCord : float, input := .0):
	if not Network.is_owned(OwnerID): return MotionCord
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
		
	elif not Global.handInput("ui_jump", true) and not jumpReleased:
		motion.y /= 2
		jumpReleased = true
		snapDesatived = false

func _coyoteTimer():
	if not Network.is_owned(OwnerID): return
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
	return onFloor() and abs(spriteGizmo.rotation) >= 0.4

func onWall():
	var distance := 28
	var rayDirection := 0.0
	
	for ray in onWallRayCast:
		if !ray.is_colliding(): continue
		
		var normal = ray.get_collision_normal()
		if abs(normal.y) > 0.5: continue
		
		var point = abs(to_local(ray.get_collision_point()).x)
		if point < distance: distance = point
		
		rayDirection = sign(ray.cast_to.x)
	
	var result = distance < 16.8 and distance >= 15
	
	if not result: return false
	
	if result and  rayDirection != Global.handInputAxis("ui_left", "ui_right") and active:
		if Input.get_axis("ui_left", "ui_right") != 0 and motion.x:
			motion.x = 0
			return true
		
	if result:
		if rayDirection == sign(motion.x):
			motion.x = 0
			
		global_position.x += (distance - 16) * rayDirection
		return true

func getSlopeNormal():
	var finalNormal := Vector2.ZERO
	var normals := []
	
	if $slopeDetect.is_colliding(): normals.append($slopeDetect.get_collision_normal())
	if $slopeDetectLeft.is_colliding(): normals.append($slopeDetectLeft.get_collision_normal())
	if $slopeDetectRight.is_colliding(): normals.append($slopeDetectRight.get_collision_normal())
	
	for i in normals:
		finalNormal += i
	
	if normals:
		finalNormal.x /= normals.size()
		finalNormal.y /= normals.size()
		
		return finalNormal
	
	return Vector2.UP

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

func hitboxTriggered(damage : DamageAttack):
	if not ("enemy" in damage.objectGroup and not shieldActived):
		return

	var direction : int = damage.direction.x
	emit_signal("damaged", direction)
	health -= damage.damage
	$"../HUD".setHealth(health)
	shieldActived = true

func coyoteTimerTimeout():
	canJump = false
		
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

func taunt(_tauntName):
	pass

func getSprite(spriteKey : String, spriteNode : NodePath):
	get_node(spriteNode).texture = LoadedObjects.textures[spriteKey % Players.playerList[OwnerID].character]
	
func updateHueshift(newShift : int):
	Players.playerList[OwnerID].colorShift = newShift
