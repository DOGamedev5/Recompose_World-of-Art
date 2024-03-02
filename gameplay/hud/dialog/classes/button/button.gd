extends Control

onready var rect = $NinePatchRect
onready var text = $NinePatchRect/Label

func _ready():
	setSize()
	
func pressed():
	print("me aperto")

func setSize():
	var size = text.rect_size.x + 16
	rect.rect_size.x = size
	rect_min_size = rect.rect_size
