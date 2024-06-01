extends CanvasLayer

var texts : Array

onready var currentText = $Control/NinePatchRect/HBoxContainer/MarginContainer/VBoxContainer/RichTextLabel
onready var options = $Control/NinePatchRect/HBoxContainer/MarginContainer/VBoxContainer/options
onready var rect = $Control/NinePatchRect
onready var tween = $Tween
onready var reaction = $Control/NinePatchRect/HBoxContainer/TextureRect
onready var characterName = $Control/NinePatchRect/HBoxContainer/MarginContainer/VBoxContainer/name

onready var font = preload("res://entities/classes/dialogComponent/dialog.tres")
onready var button = preload("res://entities/classes/dialogComponent/classes/button/buttonDialog.tscn")

export(NodePath) var interactBallonPath
var interactBallon

export(Array, Texture) var images

signal optionChosen(question, option)
signal dialogClosed
signal dialogOpened

var textIndex := 0
var actived := false
var hasInteracted := false
var optionID := 0
var isQuestion := false

var player : PlayerBase = null

func _ready():
	rect.rect_pivot_offset = rect.rect_size/2
	
	if interactBallonPath:
		interactBallon = get_node(interactBallonPath)
		var _1 = interactBallon.connect("interacted", self, "interacted")

func _process(_delta):
	var optionsList = options.get_children()
	
	for opt in range(optionsList.size()):
		if opt == optionID:
			options.get_child(opt).updateTexture(1)
			continue
		
		optionsList[opt].updateTexture(0)
	
	if Input.is_action_just_pressed("ui_right") and optionID < optionsList.size()-1:
		optionID += 1
	
	elif Input.is_action_just_pressed("ui_left") and optionID > 0:
		optionID -= 1

func setup(Texts):
	textIndex = 0
	if texts:
		texts.clear()
	texts.append_array(Texts)

func addText(text : String):
	texts.append(text)

func addQuestion(question : Question):
	texts.append(question)

func addDialog(dialog : Array):
	texts.append_array(dialog)

func ativeded():
	hasInteracted = true
	player.moving = false
	
	tween.interpolate_property(rect, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.3,
	Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	emit_signal("dialogOpened")

func desactiveded(Player = player):
	tween.remove_all()
	actived = false
	hasInteracted = false
	Player.moving = true
	player = null
	
	tween.interpolate_property(rect, "rect_scale", rect["rect_scale"], Vector2(0, 0), 0.4,
	Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	
	if not tween.is_inside_tree():
		yield(tween, "tree_entered")
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	for option in options.get_children():
		option.queue_free()
	
	emit_signal("dialogClosed")
	
func interacted(Player):
	
	player = Player
	
	if isQuestion:
		emit_signal("optionChosen", texts[textIndex].question, texts[textIndex].options[optionID])
		isQuestion = false
	
	for option in options.get_children():
		option.queue_free()
		
	if !hasInteracted:
		ativeded()
		textIndex = 0
		
	elif currentText.percent_visible == 1:
		var maxTexts = texts.size() - 1

		if textIndex >= maxTexts:
			desactiveded()
			
			return
		else:
			textIndex += 1
	
	else:
		tween.remove(currentText, "percent_visible")
		currentText.percent_visible = 1
		
		return
	
	_setText(texts[textIndex])

func _setText(text):
	
	if text is Dictionary:
		if text.has("image"):
			reaction.visible = true
			reaction.texture["atlas"] = images[text["image"]]
			
			if text.has("react"):
				reaction.texture["region"].position.x = text["react"]*92
				
			else:
				reaction.texture["region"].position.x = 0
			
		else:
			reaction.visible = false
			reaction.texture["atlas"] = null
		
		if text.has("name"):
			characterName.text = text["name"]
			characterName.visible = true
			
		else:
			characterName.visible = false
		
		currentText.bbcode_text = tr(text["text"])
		
	else:
		reaction.visible = false
		reaction.texture["atlas"] = null
		reaction.texture["region"].position.x = 0
		
		characterName.visible = false
	
	if text is String:
		currentText.bbcode_text = tr(text)
		
	elif text is Question:
		isQuestion = true

		currentText.bbcode_text = tr(text.question)
		
		for option in text.options:
			var newOption = button.instance()
			newOption.text = tr(option)
			
			options.add_child(newOption)
			newOption.updateTexture(0)
			newOption.setSize()
	
	tween.interpolate_property(currentText, "percent_visible", 0, 1, (currentText.text.length() / 10) * 0.35,
	Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	tween.start()
	
