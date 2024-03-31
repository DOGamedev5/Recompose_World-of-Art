tool
extends Node

export var fliped := false setget _setFliped
export(NodePath) var visiblility

func _ready():
#	var _1 = connect("script_changed", self, "scriptChanged")
	if visiblility:
		var visibily = get_node(visiblility)
	
		var _2 = visibily.connect("screen_entered", self, "ative")
		var _3 = visibily.connect("screen_exited", self, "desative")
	
	var _4 = Global.connect("simpleLightChanged", self, "_toggledSimpleLight")
	
	_toggledSimpleLight(Global.simpleLight)

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
	$Light2D.enabled = false

func ative():
	if not Global.simpleLight:
		$Light2D.enabled = true

func _toggledSimpleLight(value):
	$Light.visible = value
	$Light2D.enabled = !value
