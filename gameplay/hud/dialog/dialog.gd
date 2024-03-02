extends CanvasLayer

var texts : Array

onready var currentText = $Control/NinePatchRect/RichTextLabel
onready var options = $Control/NinePatchRect/options
onready var rect = $Control/NinePatchRect
onready var tween = $Tween

onready var font = preload("res://gameplay/hud/dialog/dialog.tres")
onready var button = preload("res://gameplay/hud/dialog/classes/button/button.tscn")

export(NodePath) var interactBallonPath
var interactBallon

var player

var textIndex := 0
var actived := false
var interacted := false

func _ready():
	rect.rect_pivot_offset = rect.rect_size/2
	interactBallon = get_node(interactBallonPath)
	interactBallon.connect("interacted", self, "interacted")

func activeded(Player, Texts):
	
	actived = true
	textIndex = 0
	texts = Texts
	currentText.bbcode_text = texts[textIndex]

	player = Player

func desactiveded():
	actived = false
	player = null
	interacted = false
	

func interacted():
	if actived and !interacted:
		textIndex = 0
		currentText.bbcode_text = texts[textIndex]
		interacted = true
		
		tween.interpolate_property(rect, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.3,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	
	elif actived and interacted:
		var maxTexts = texts.size() - 1
		if textIndex < maxTexts:
			textIndex += 1
			_setText()
		else:
			interacted = false
			tween.interpolate_property(rect, "rect_scale", Vector2(1, 1), Vector2(0, 0), 0.4,
			Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
			tween.start()
			
			yield(tween, "tween_all_completed")
			for option in options.get_children():
				option.queue_free()

func _setText():
	var text = texts[textIndex]
	if text is String:
		currentText.bbcode_text = text
	elif text is Question:
		currentText.bbcode_text = text.question
		for option in text.options:
			var newOption = button.instance()
			newOption
			options.add_child(newOption)
