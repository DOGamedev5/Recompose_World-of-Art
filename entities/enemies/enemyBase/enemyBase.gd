class_name EnemyBase extends EntityBase

export(NodePath) var visionAreaPath
onready var visionArea := get_node_or_null(visionAreaPath)
export(Array, NodePath) var attackAreaArray 
export(NodePath) var hitboxAreaPath
onready var hitboxArea := get_node_or_null(hitboxAreaPath)
export(NodePath) var spritePath
onready var sprite := get_node_or_null(spritePath)
export(Texture) var deathSprite
export(NodePath) var animationTreePath
onready var animationTree = get_node(animationTreePath)
onready var animationPlayback = animationTree["parameters/playback"]

onready var scenePath : String

export var maxHealth := 20
export var health := 20

export var flipArea := false

export var unlimitedVision  := false
export var fliped := false
export var canUnwatch := false 

onready var enemyDeath := preload("res://entities/enemies/enemyDeath/enemyDead.tscn")

var player = null
var flipLock := false

signal defeated(enemy)

func _ready():
	OwnerID = Network.steamID
	scenePath = get_path()
	
	var timer = Timer.new()
	timer.wait_time = 0.05
	timer.connect("timeout", self, "_networkUpdate")
	add_child(timer)
	timer.start()
	
	add_to_group("enemy")
	if visionArea:
		
		if not "enemyVision" in visionArea.get_groups():
			visionArea.add_to_group("enemyVision")
		
		visionArea.set_collision_layer_bit(11, true)
	
	if hitboxArea:
		hitboxArea.connect("HitboxDamaged", self, "hitted")
	

func gravityProcess():
	if not onFloor():
		
		motion.y += GRAVITY
		if motion.y > MAXFALL:
			motion.y = MAXFALL

func _physics_process(_delta):
#	if stateMachine:
#		stateMachine.processMachine(delta)
	
	gravityProcess()
	
	if player and not flipLock:
		
		
		if motion.x:
			fliped = motion.x < 0
#		elif Global.player and visionArea:
#			fliped = Global.player.global_position.x < global_position.x
	
	sprite.flip_h = fliped
	
	if attackAreaArray and flipArea:
		var direction := (1 - 2 * int(fliped))
		
		for attackPath in attackAreaArray:
			var attack = get_node(attackPath)
			attack.position.x *= sign(attack.position.x) * direction
		
		if visionArea:
			visionArea.position.x *= sign(visionArea.position.x) * direction
	
	motion = move_and_slide(motion, Vector2.UP, true, 4, deg2rad(80), true)

func moveBase(input : int, MotionCord : float, maxSpeed : float = MAXSPEED, ACCEL := ACCELERATION):
	MotionCord += input * ACCEL
	
	if abs(MotionCord) > maxSpeed:
		MotionCord = maxSpeed * sign(MotionCord) 
	
	if sign(MotionCord) != input:
		var saveSign = sign(MotionCord)
		MotionCord -=  DESACCELERATION * saveSign
		if (MotionCord != 0 and sign(MotionCord) != saveSign) and input == 0:
			MotionCord = 0
	
	return MotionCord

func desaccelete(MotionCord, input := 0, desacceleration := DESACCELERATION):
	if sign(MotionCord) != input:
		var saveSign = sign(MotionCord)
		MotionCord -=  desacceleration * saveSign
		if (MotionCord != 0 and sign(MotionCord) != saveSign) and input == 0:
			MotionCord = 0
	
	return MotionCord

func onFloor():
	if !gravity: return true
	return is_on_floor()

func hitted(damage : DamageAttack):
	if damage.damage <= 0 or health <= 0:
		return
	modulate = Color(4, 4, 4, 1)
	get_tree().create_timer(0.1).connect("timeout", self, "damageTimer")
	health -= damage.damage
	
	if health <= 0:
		var smoke = load("res://objects/dustBlow/dustBlow.tscn").instance()
		smoke.amount = 12
		owner.add_child(smoke)
		smoke.lifetime = 0.8
		smoke.preprocess = 0.4
		smoke.global_position = global_position
		
		emit_signal("defeated", self)
		
		var death = enemyDeath.instance()
		death.texture = deathSprite
		death.direction = sign(damage.direction.x)
		
		get_parent().get_parent().add_child(death)
		death.global_position = global_position
		death.flip_h = sprite.flip_h
		
		queue_free()
		return

func damageTimer():
	modulate = Color.white

func sendPacket(data : Dictionary):
	Network.sendP2PPacket(Network.get_host(), {
		"type" : "objectUpdateCall",
		"method" : "readyCount",
		"objectPath" : get_path(),
		"value" : [data]
	}, 
	Steam.NETWORKING_SEND_UNRELIABLE)

func receivePacket(_data : Dictionary):
	pass

func _networkUpdate():
	pass
