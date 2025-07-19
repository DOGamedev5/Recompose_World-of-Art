class_name EntityBase extends KinematicBody2D

export(NodePath) var stateMachinePath
onready var stateMachine : StateMachine = get_node_or_null(stateMachinePath)

export var gravity := true
export var ACCELERATION := 3
export var DESACCELERATION := 10
export var GRAVITY := 10
export var MAXSPEED := 350
export var MAXFALL := 300
export var JUMPFORCE := -400
export var MAXHEALTH := 400
export var OwnerID := -1

var motion := Vector2.ZERO

func onFloor():
	if !gravity: return true
	return is_on_floor()

func gravityBase():
	if not onFloor():
		
		motion.y += GRAVITY
		if motion.y > MAXFALL:
			motion.y = MAXFALL

func _networkUpdate():
	pass

func receivePacket(_packet):
	pass
