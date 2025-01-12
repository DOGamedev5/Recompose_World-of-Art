extends PlayerBase

onready var sprite = $sprite/Sprite
onready var animation = $AnimationTree

onready var playback = animation["parameters/playback"]
onready var counchPlayback = animation["parameters/COUNCH/COUNCH/playback"]
onready var normalPlayback = animation["parameters/NORMAL/NORMAL/playback"]
onready var walledPlayback = animation["parameters/WALLED/WALLED/playback"]
onready var ladderPlayback = animation["parameters/LADDER/StateMachine/playback"]
onready var topSpeedPlayback = animation["parameters/RUN/RUN/playback"]

onready var attackComponents = [$attackPunch, $attackSpeed, $attackRoll]
onready var currentCollision = $CollisionShape2D
onready var attackDelay = $StateMachine/ATTACK/attackDelay

onready var specialEffect := preload("res://entities/player/powerStates/normal/particle/particle.tscn")

export(float) var runningVelocity := 550.0

var running := false
var canAttackTimer := .0
var attackTime := 20.0
var attackVelocity := 800.0
var isRolling := false
var canAttack := true

onready var collisionShapes := [
	{obj = $CollisionShape2D, onWall = [true, true, true]},
	{obj = $CollisionShape2D3, onWall = [false, true, true]}
]

onready var stepSFX = [
	preload("res://entities/player/sfx/step.ogg")
]

func _enter_tree():
	$sprite/Sprite.hframes = 23
	
func _physics_process(delta):
	if not active: return
	
	physics_process(delta)
	_coyoteTimer()
	setFlipConfig()
	setAttack()
	
	rotateSprite(delta)
	
	if active: move()
	
	if OS.is_debug_build(): $a/Label.text = String($sprite.rotation)
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

func rotateNormal(delta):
	var floorNormal : Vector2 = .rotateNormal(delta)
	
	if not onFloor()and running: floorNormal.x *= -1
	
	return floorNormal

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
		owner.add_child(smoke)
		smoke.global_position = global_position - Vector2(0, 32)
	
	running = abs(velocity) > MAXSPEED

func setFlipConfig():
	if stunned: return
	
	flipObject(attackComponents)
	
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
	collisionShapes[ID].obj.disabled = false
	
	for obj in range(collisionShapes.size()):
		if obj == ID: continue
		collisionShapes[obj].obj.disabled = true

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
		AudioManager.playSFX(sfx, {"pitch_scale" : rand_range(0.9, 1)})
