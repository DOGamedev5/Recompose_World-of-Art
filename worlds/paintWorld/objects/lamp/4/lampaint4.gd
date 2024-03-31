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
	$lamp/Light2D.enabled = false

func ative():
	if not Global.simpleLight:
		$lamp/Light2D.enabled = true

func _toggledSimpleLight(value):
	$lamp/Light.visible = value
	$lamp/Light2D.enabled = !value
