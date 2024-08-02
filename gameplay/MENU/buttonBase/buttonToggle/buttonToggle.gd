extends Button

onready var tween = $Tween
onready var base = $ButtonToggleBase
onready var button = $ButtonToggleBase/button
export var active = true
		
		
func _ready():
	var _1 = connect("toggled", self, "_on_CheckButton_toggled")
	
	if pressed:
		pressedTween()
	else:
		releasedTween()

func releasedTween():
	button.texture["region"].position.x = 0
	base.texture["region"].position.x = 0
	
	tween.interpolate_property(button, "rect_position",
		button["rect_position"], Vector2(4, -2), 0.2,
		Tween.TRANS_QUINT, Tween.EASE_OUT)
		
	tween.start()

func pressedTween():
	button.texture["region"].position.x = 10
	base.texture["region"].position.x = 26
	
	tween.interpolate_property(button, "rect_position",
		button["rect_position"], Vector2(28, -2), 0.2,
		Tween.TRANS_QUINT, Tween.EASE_IN)
		
	tween.start()


func _on_CheckButton_toggled(button_pressed = pressed):
	if not active: return
	if button_pressed:
		pressedTween()
	else:
		releasedTween()
