extends CanvasLayer

onready var paper = $Control/NinePatchRect
onready var paperText = $Control/NinePatchRect/Label
onready var tween = $Tween
onready var timer = $Timer

export(String) var text
export(NodePath) var interactBallon

func _ready():
	paperText.text = text
	
	if interactBallon:
		var ballon = get_node(interactBallon)
		
		var _1 = ballon.connect("interacted", self, "interacted")

func interacted():
	_setLengh()

func showText(Text):
	paperText.text = Text
	_setLengh()

func _setLengh():
	var textLenght = paperText.text.length()
	
	var newLenght = (textLenght*8 + (textLenght-1))*4 + 18
	
	paper.visible = true
	tween.interpolate_property(
		paper, "rect_size", paper["rect_size"], Vector2(newLenght, paper["rect_size"].y), 0.6,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		paper, "rect_position", paper["rect_position"], Vector2(1260 - newLenght+68, paper["rect_position"].y), 0.6,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	
	tween.start()
	
	timer.start()

func _on_Timer_timeout():
	tween.interpolate_property(
		paper, "rect_size", paper["rect_size"], Vector2(68, paper["rect_size"].y), 0.6,
		Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	tween.interpolate_property(
		paper, "rect_position", paper["rect_position"], Vector2(1260, paper["rect_position"].y), 0.6,
		Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	tween.start()
	
	yield(tween, "tween_completed")
	
	paper.visible = false
