tool
extends "res://worlds/paintWorld/objects/lamp/lamp.gd"

export var ropeLenght := 50 setget _setLenght
onready var rope = $rope
onready var lampaint = $lamp

func scriptChanged():
	ropeLenght = ropeLenght
	fliped = fliped

func _setLenght(value):
	ropeLenght = value
	$rope.points[1].y = 10 + value
	$lamp.position.y = 10 + value

func desative():
	light.enabled = false

func ative():
	if not Global.options.simpleLight:
		light.enabled = true

func _toggledSimpleLight(value):
	$lamp/Light.visible = value
	light.enabled = !value

func _toggledShadow(value):
	light.shadow_enabled = value
