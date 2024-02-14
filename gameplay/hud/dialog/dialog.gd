extends CanvasLayer

var texts : Array

onready var currentText = $Control/NinePatchRect/RichTextLabel
onready var options = $Control/NinePatchRect/options

onready var font = preload("res://gameplay/hud/dialog/dialog.tres")

var player

var textIndex := 0
var actived := false

func activeded(Player, Texts):
	actived = true
	textIndex = 0
	texts = Texts
	currentText.bbcode_text = texts[textIndex]

	player = Player

func desactiveded():
	actived = false
	player = null
	visible = false

func _input(event):
	if Input.is_action_just_pressed("interact") and actived and !visible:
		textIndex = 0
		currentText.bbcode_text = texts[textIndex]
		visible = true
		
	elif Input.is_action_just_pressed("confirm") and visible:
		var maxTexts = texts.size() - 1
		if textIndex < maxTexts:
			textIndex += 1
			_setText()
		else:
			visible = false

func _setText():
	var text = texts[textIndex]
	if text is String:
		currentText.bbcode_text = text
	elif text is Question:
		currentText.bbcode_text = text.question
		for option in text.options:
			var label = Label.new()
			label.text = option
			label["custom_fonts/font"] = font
			options.add_child(label)
