tool
extends Node

export var fliped := false setget _setFliped
export(NodePath) var visiblility
export(Vector2) var lightPosition
export(NodePath) var lightPath
onready var light : Light2D = get_node(lightPath)

func _ready():
	
	if visiblility:
		var visibily = get_node(visiblility)
	
		var _2 = visibily.connect("screen_entered", self, "ative")
		var _3 = visibily.connect("screen_exited", self, "desative")
	
	if Global.is_inside_tree():
		light.enabled = !Global.options.simpleLight
		light.shadow_enabled = Global.options.shadows

func _setFliped(value):
	fliped = value
	var flipInt := 1 - (int(fliped) * 2)
	for node in get_children():
		if node is Sprite:
			node.flip_h = fliped
		
		node.position.x *= sign(node.position.x) * flipInt 

func scriptChanged():
	fliped = fliped

func desative():
	light.enabled = false

func ative():
	if not Global.options.simpleLight:
		light.enabled = true

func _toggledSimpleLight(value):
	$Light.visible = value
	light.enabled = !value

func _toggledShadow(value):
	light.shadow_enabled = value
