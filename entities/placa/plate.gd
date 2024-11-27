tool
extends Node2D

export(Array, String) var content = ["?"] 
export var fliped := false setget flipedSet

func _ready():
	informationSet(content)

func informationSet(value):
	content = value
	if not is_inside_tree(): return
	$interactBallon.changed(value)

func flipedSet(value):
	fliped = value
	if not is_inside_tree():
		return
	$Plate.flip_h = value
