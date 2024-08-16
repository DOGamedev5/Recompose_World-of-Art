tool
extends Node

export var fliped := false setget _setFliped
export(NodePath) var visiblility
export(Vector2) var lightPosition
export(NodePath) var lightPath
var light

func _ready():
	light = get_node(lightPath)
	
	if visiblility:
		var visibily = get_node(visiblility)
	
		var _2 = visibily.connect("screen_entered", self, "ative")
		var _3 = visibily.connect("screen_exited", self, "desative")
	
	var _4 = Global.connect("simpleLightChanged", self, "_toggledSimpleLight")
	var _5 = Global.connect("shadowsChanged", self, "_toggledShadows")
	
	_toggledSimpleLight(Global.options.simpleLight)
	_toggledShadows(Global.options.shadows)

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

func _toggledShadows(value):
	light.shadow_enabled = value
