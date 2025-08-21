extends PlayerBase

onready var sprite = $sprite/Sprite
onready var animation = $AnimationTree

onready var playback : AnimationNodeStateMachinePlayback= animation["parameters/playback"]
onready var counchPlayback : AnimationNodeStateMachinePlayback = animation["parameters/COUNCH/COUNCH/playback"]
onready var normalPlayback : AnimationNodeStateMachinePlayback = animation["parameters/NORMAL/NORMAL/playback"]
onready var walledPlayback : AnimationNodeStateMachinePlayback = animation["parameters/WALLED/WALLED/playback"]
onready var ladderPlayback : AnimationNodeStateMachinePlayback = animation["parameters/LADDER/LADDER/playback"]
onready var tauntPlayback : AnimationNodeStateMachinePlayback = animation["parameters/TAUNT/TAUNT/playback"]
onready var topSpeedPlayback : AnimationNodeStateMachinePlayback = animation["parameters/RUN/RUN/playback"]

onready var attackComponents = [$attackPunch, $attackSpeed, $attackRoll]
onready var currentCollision = $CollisionShape2D
onready var attackDelay = $StateMachine/ATTACK/attackDelay

onready var specialEffect := preload("res://entities/player/powerStates/normal/particle/particle.tscn")
onready var effects := [preload("res://objects/dustBlow/dustBlow.tscn")]

export(float) var runningVelocity := 550.0

var running := false
var canAttackTimer := .0
var attackTime := 20.0
var attackVelocity := 800.0
var isRolling := false
var canAttack := true
var lastUpdate := 0

onready var collisionShapes := [
	{obj = $CollisionShape2D, onWall = [true, true, true], hitbox = $HitboxComponent/CollisionShape2D},
	{obj = $CollisionShape2D3, onWall = [false, true, true], hitbox = $HitboxComponent/CollisionShape2D2}
]

onready var stepSFX = [
	preload("res://entities/player/sfx/step.ogg")
]
	
func _enter_tree():
	$sprite/Sprite.hframes = 23
	
func _ready():
	$sprite.material["shader_param/hue_shift"] = Players.playerList[OwnerID].colorShift
	if not Network.is_owned(OwnerID):
		for attack in attackComponents:
			attack.setDamage(0)
	

func _physics_process(delta):
	if not active or not Network.is_owned(OwnerID): return
	
	physics_process(delta)
	_coyoteTimer()
	setFlipConfig()
	setAttack()
	
	rotateSprite(delta)
	
	if active: move()

	if OS.is_debug_build(): $a/Label.text = String("")
	elif get_node_or_null("a"): $a.queue_free()
	
	$sprite/speedEffect.visible = running and not isRolling
	if running and not isRolling:
		var velocity = abs(motion.x)
		if onSlope():
			velocity = abs(sqrt(pow(motion.x, 2) + pow(motion.y, 2)))
		
		var value = max((velocity - MAXSPEED) / (runningVelocity - MAXSPEED-100), 0.65) 
		
		$sprite/speedEffect.modulate.a = value
		$sprite/speedEffect.modulate.r = 1 + value * 0.5
		$sprite/speedEffect.modulate.g = 1 + value * 0.5
		
	if attackDelay.is_stopped():
		canAttack = true
	else:
		canAttack = false

func _networkUpdate():
	if Network.lobbyID == -1: return
	if Steam.getNumLobbyMembers(Network.lobbyID) <= 1: return
	var animationTreePlay := playback.get_current_node()
	var currentAnimation : String = ""
	
	if not animationTreePlay in ["ATTACK", "DAMAGE"]:
		currentAnimation = animation["parameters/{n}/{n}/playback".format({"n" : animationTreePlay})].get_current_node()
	
	Network.sendP2PPacket(-1, {"type" : "playerUpdate",
		"sender" : [Network.steamID, Network.conectionType, Network.connectionOwner],
		"animationsPlaying" : animationTreePlay,
		"animationName" : currentAnimation,
		"motion" : motion,
		"sprite_rotation" : $sprite.rotation,
		"global_position" : global_position,
		"currentState" : stateMachine.currentState.name,
		"updateTimer" : Time.get_unix_time_from_system()
	}, Steam.P2P_SEND_UNRELIABLE)

func receivePacket(packet):
	if packet["updateTimer"] < lastUpdate: return
	lastUpdate = packet["updateTimer"]
	
	playback.travel(packet["animationsPlaying"])
	if packet["animationName"]:
		animation["parameters/{n}/{n}/playback".format({"n" : packet["animationsPlaying"]})].travel(packet["animationName"])
	
	global_position = packet["global_position"]
#	stateMachine.changeState(packet["currentState"])
	motion = packet["motion"]
	$sprite.rotation = packet["sprite_rotation"]


func rotateNormal(delta):
	var floorNormal : Vector2 = .rotateNormal(delta)
	
	if not onFloor() and (running or isRolling):
		floorNormal = Vector2(sin(motion.angle()), cos(motion.angle()))
	
	return floorNormal

func rotateSprite(delta):
	if not spriteGizmo: return
	
	if lockRotate:
		$sprite.rotation = 0
		return
	
	var floorNormal : Vector2 = rotateNormal(delta)
	var weight := 20
	
	var angle : float = max(min(atan2(float(floorNormal.x), -float(floorNormal.y)), deg2rad(45)), deg2rad(-45))
	if not onFloor():
		weight = 10
	
		if running or isRolling:
			angle = motion.angle()
			if motion.x < 0:
				angle += PI
	
	$sprite.rotation = lerp_angle($sprite.rotation, angle, weight * delta)

func stoppedRunning():
	var velocity = motion.x
	if onSlope():
		velocity = sqrt(pow(motion.x, 2) + pow(motion.y, 2))
		
	if running and abs(velocity) <= MAXSPEED:
		running = false

func detectRunning():
	var velocity = motion.x
	if onSlope():
		velocity = sqrt(pow(motion.x, 2) + pow(motion.y, 2))
	
	if not running and abs(velocity) > MAXSPEED:
		var smoke : CPUParticles2D = load("res://objects/dustBlow/dustBlow.tscn").instance()
		smoke.amount = 12
		smoke.lifetime = 0.6
		smoke.preprocess = 0.2
		get_parent().add_child(smoke)
		smoke.global_position = global_position - Vector2(0, 32)
	
	running = abs(velocity) > MAXSPEED

func setFlipConfig():
	if stunned: return
	
#	flipObject(attackComponents)
	for attack in attackComponents:
		attack.rotation = PI * int(fliped)
	
	$sprite/speedEffect.position.x = 28 * (1 - 2 * int(fliped))
	$sprite/speedEffect.flip_h = fliped
	
	sprite.flip_h = fliped

func setAttack():
	if running and not isRolling:
		if sqrt(pow(motion.x, 2) + pow(motion.y, 2)) < 725:
			attackComponents[1].setDamage(1)
		else:
			attackComponents[1].setDamage(2)
	else:		
		attackComponents[1].setDamage(0)
		
func setCollision(ID := 0):
	collisionShapes[ID].obj.set_deferred("disabled", false)
	collisionShapes[ID].hitbox.set_deferred("disabled", false)
	
	for obj in range(collisionShapes.size()):
		if obj == ID: continue
		
		collisionShapes[obj].obj.disabled = true
		
		if collisionShapes[obj].hitbox != collisionShapes[ID].hitbox:
			collisionShapes[obj].hitbox.set_deferred("disabled", true)
	
	for ray in range(3):
		onWallRayCast[ray].enabled = collisionShapes[ID].onWall[ray]
	
func _on_specialEffectTimer_timeout():
	if running:
		var newEffect := specialEffect.instance()
		newEffect.currentSprite = sprite
		get_parent().add_child(newEffect)
		newEffect.position = position - Vector2(0, 32)
		newEffect.rotation = spriteGizmo.rotation
		
func _stepSfx():
	var sfx = stepSFX[0]
	if is_on_floor():
		AudioManager.playSFX(sfx, {"pitch_scale" : rand_range(0.9, 1)}, true, global_position, 256)

func taunt(tauntName):
	$StateMachine/TAUNT.currentTaunt = tauntName
	$StateMachine/TAUNT.update()
	stateMachine.changeState("TAUNT")

func updateHueshift(newShift : int):
	.updateHueshift(newShift)
	$sprite.material["shader_param/hue_shift"] = Players.playerList[OwnerID].colorShift

func setupSprite():
	.setupSprite()
	$sprite/Sword.visible = Players.getPlayerCharater(OwnerID) == "alexandry"
		
