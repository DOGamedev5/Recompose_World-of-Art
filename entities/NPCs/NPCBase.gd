class_name NPCBase extends KinematicBody2D

export(NodePath) var interactionBallonPath
export(NodePath) var spritePath
export var fliped := false setget setFliped

var interactBallon
var sprite
var playerNode

var direction


func _ready():
	direction = 1 - (int(fliped) * 2)
	
	if interactionBallonPath:
		interactBallon = get_node(interactionBallonPath)
		var _1 = interactBallon.connect("entered", self, "_playerEntered")
		var _2 = interactBallon.connect("exitered", self, "_playerExitered")
		
	
	if spritePath:
		sprite = get_node(spritePath)

func _physics_process(_delta):
	if playerNode:
		direction = sign(playerNode.global_position.x - global_position.x)
		fliped = direction != 1
	
	sprite.flip_h = fliped

func setFliped(value):
	fliped = value
	if sprite:
		sprite.flip_h = fliped

func _playerEntered(player):
	playerNode = player

func _playerExitered(_player):
	playerNode = null
