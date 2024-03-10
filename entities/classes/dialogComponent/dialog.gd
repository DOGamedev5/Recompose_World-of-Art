extends CanvasLayer

var texts : Array

onready var currentText = $Control/NinePatchRect/RichTextLabel
onready var options = $Control/NinePatchRect/options
onready var rect = $Control/NinePatchRect
onready var tween = $Tween

onready var font = preload("res://entities/classes/dialogComponent/dialog.tres")
onready var button = preload("res://entities/classes/dialogComponent/classes/button/buttonDialog.tscn")

export(NodePath) var interactBallonPath
var interactBallon

var textIndex := 0
var actived := false
var hasInteracted := false
var optionID := 0

var player : PlayerBase = null

func _ready():
	rect.rect_pivot_offset = rect.rect_size/2
	interactBallon = get_node(interactBallonPath)
	
	var _1 = interactBallon.connect("interacted", self, "interacted")
	var _2 = interactBallon.connect("exitered", self, "desactiveded")

func _process(_delta):
	var optionsList = options.get_children()
	
	for opt in range(optionsList.size()):
		if opt == optionID:
			options.get_child(opt).updateTexture(1)
			continue
		
		optionsList[opt].updateTexture(0)

func setup(Texts):
	textIndex = 0
	texts = Texts
	_setText()

func ativeded():
	hasInteracted = true
	player.moving = false
	
	tween.interpolate_property(rect, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.3,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func desactiveded(Player = player):
	actived = false
	hasInteracted = false
	Player.moving = true
	player = null 
	
	tween.interpolate_property(rect, "rect_scale", Vector2(1, 1), Vector2(0, 0), 0.4,
	Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	for option in options.get_children():
		option.queue_free()
	
func interacted(Player):
	
	player = Player
	
	for option in options.get_children():
		option.queue_free()
		
	if !hasInteracted:
		ativeded()
		textIndex = 0
		
	else:
		var maxTexts = texts.size() - 1

		if textIndex >= maxTexts:
			desactiveded()
		else:
			textIndex += 1
	
	_setText()

			
func _setText():
	var text = texts[textIndex]
	if text is String:
		currentText.bbcode_text = text
		
	elif text is Question:
		currentText.bbcode_text = text.question
		
		for option in text.options:
			var newOption = button.instance()
			newOption.text = option
			
			options.add_child(newOption)
			newOption.updateTexture(0)
			newOption.setSize()
