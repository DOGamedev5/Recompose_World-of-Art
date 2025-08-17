class_name NPCBase extends KinematicBody2D

export(NodePath) var interactionBallonPath
export(NodePath) var spritePath
export(NodePath) var animationPath

export var fliped := false setget setFliped
export var canFlip := true
export var cinematic := false

var interactBallon
var sprite
var animationNode

var entered := false

var direction

func _init():
	collision_layer = 0
	collision_mask = 0


func _ready():
	direction = 1 - (int(fliped) * 2)
	
	if interactionBallonPath:
		interactBallon = get_node(interactionBallonPath)
		var _1 = interactBallon.connect("entered", self, "_playerEntered")
		var _2 = interactBallon.connect("exitered", self, "_playerExitered")
		
	if spritePath:
		sprite = get_node(spritePath)
	
	if animationPath:
		animationNode = get_node(animationPath)

func _physics_process(_delta):
	if entered and canFlip and not cinematic:
		direction = sign(Global.player.global_position.x - global_position.x)
		fliped = direction != 1
	
	sprite.flip_h = fliped

func setFliped(value):
	fliped = value
	if sprite:
		sprite.flip_h = fliped

func _playerEntered():
	entered = true

func _playerExitered():
	entered = false


