extends Button

onready var label = $Label
onready var nineTexture = $NinePatchRect
onready var timer = $Timer
export var active = true setget setActive
export var disatived = false

var isPressed := false

func _ready():
	setSize()

func _pressed():
	nineTexture.region_rect.position.x = 96*2

func _process(_delta):
	if disatived:
		modulate = Color(0.6, 0.6, 0.6)
	else:
		modulate = Color.white
	
	if is_hovered() and not isPressed and active and not disatived:
		nineTexture.region_rect.position.x = 96
	elif not isPressed:
		nineTexture.region_rect.position.x = 0
	
func setSize():
	label.set_text(text)

func setActive(value):
	active = value
	disabled = not value or disatived

func _on_buttonMenu_pressed():
	if not active: return
	timer.start()
	isPressed = true
	nineTexture.region_rect.position.x = 96*2


func _on_Timer_timeout():
	isPressed = false
