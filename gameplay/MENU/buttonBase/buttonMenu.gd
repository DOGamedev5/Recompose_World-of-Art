extends Button

onready var label = $Label
onready var nineTexture = $NinePatchRect

func _ready():
	setSize()

func _pressed():
	nineTexture.region_rect.position.x = 96*2

func _process(_delta):
	if is_hovered() and not pressed:
		nineTexture.region_rect.position.x = 96
	elif not pressed:
		nineTexture.region_rect.position.x = 0
	
func setSize():
	label.set_text(text)
