extends Button

onready var label = $Label
onready var nineTexture = $NinePatchRect
onready var timer = $Timer

var isPressed := false

func _ready():
	setSize()

func _pressed():
	nineTexture.region_rect.position.x = 96*2

func _process(_delta):
	if is_hovered() and not isPressed:
		nineTexture.region_rect.position.x = 96
	elif not isPressed:
		nineTexture.region_rect.position.x = 0
	
func setSize():
	label.set_text(text)

func _on_buttonMenu_pressed():
	timer.start()
	isPressed = true
	nineTexture.region_rect.position.x = 96*2


func _on_Timer_timeout():
	isPressed = false
