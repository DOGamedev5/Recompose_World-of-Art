#tool
extends Control

export var buttonText := "button" 
export var flipGrowDirecion := false
export var shortcut : InputEvent

onready var label = $Button/Label
onready var rect = $Button/NinePatchRect
onready var button = $Button

signal pressed

var positionBase

func _ready():
	positionBase = rect_position
	button.shortcut = shortcut
	button.shortcut = shortcut
	textChanged(buttonText)

func _process(_delta):
	if button.is_hovered() and $Timer.is_stopped():
		rect.region_rect.position.x = 32
	elif $Timer.is_stopped():
		rect.region_rect.position.x = 0


func textChanged(value):
	label.text = ""
	
	label.rect_size.x = 0
	label.text = value

func _on_Button_pressed():
	rect.region_rect.position.x = 64
	$Timer.start()
	emit_signal("pressed")

func _on_Label_resized():
	if label:
		rect_size.x = label.rect_size.x + 12
		button.rect_size.x = label.rect_size.x + 12
		if flipGrowDirecion:
			button.margin_left = -label.rect_size.x + 12
			button.margin_right = -label.rect_size.x + 12
		else:
			button.margin_left = 0
			button.margin_right = 0
