class_name EnemyBase extends KinematicBody2D

export(NodePath) var visionArea
export var flipArea := false

export var ACCELERATION := 3
export var DESACCELERATION := 20
export var GRAVITY := 10
export var MAXSPEED := 350
export var MAXFALL := 300

var motion := Vector2.ZERO
var player = null
var fliped := false

signal enteredVision(body)
signal exitedVision(body)

func _ready():
	if visionArea:
		visionArea = get_node(visionArea)
		visionArea.connect("body_entered", self, "_enteredVision")
		visionArea.connect("body_exited", self, "_exitedVision")

func _physics_process(_delta):
	if player:
		$Label.text = str(sign(player.position.x - position.x))
		fliped = player.position.x < position.x
	pass 

func _enteredVision(body):
	if body.is_in_group("player"):
		player = body
		emit_signal("enteredVision", body)

func _exitedVision(body):
	if body.is_in_group("player"):
		player = null
		emit_signal("exitedVision", body)


func moveBase(input : int, MotionCord : float, maxSpeed : float = MAXSPEED):
	MotionCord += input * ACCELERATION
	
	if abs(MotionCord) > maxSpeed:
		MotionCord = maxSpeed * sign(MotionCord) 
	
	if sign(MotionCord) != input:
		var saveSign = sign(MotionCord)
		MotionCord -=  DESACCELERATION * saveSign
		if (MotionCord != 0 and sign(MotionCord) != saveSign) and input == 0:
			MotionCord = 0
	
	return MotionCord
