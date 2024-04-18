tool
extends Node2D

export var information := "?" setget informationSet
export var fliped := false setget flipedSet

func informationSet(value):
	information = value
	$interactBallon.changed(value)

func flipedSet(value):
	fliped = value
	$Plate.flip_h = value
