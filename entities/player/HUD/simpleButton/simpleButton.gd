#tool
extends Button

export var buttonText := "button" 
export var flipGrowDirecion := false

onready var label = $Label
onready var rect = $NinePatchRect

var positionBase

func _ready():
	positionBase = rect_position
	textChanged(buttonText)

func _process(_delta):
	if is_hovered() and $Timer.is_stopped():
		rect.region_rect.position.x = 32
	elif $Timer.is_stopped():
		rect.region_rect.position.x = 0


func textChanged(value):
	label.text = ""
	
	label.rect_size.x = 0
	label.text = value

	yield(label, "resized")
	
	rect_size.x = label.rect_size.x + 12
	rect_position.x = positionBase.x - rect_size.x * int(flipGrowDirecion)

func _on_Button_pressed():
	rect.region_rect.position.x = 64
	$Timer.start()
