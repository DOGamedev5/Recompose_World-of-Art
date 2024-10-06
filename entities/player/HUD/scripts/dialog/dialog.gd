class_name DialogManager extends CanvasLayer

onready var backgroung := $Control/background
onready var rect := $Control/VBoxContainer/MarginContainer/panel
onready var speakerImage := $Control/VBoxContainer/MarginContainer/panel/HBoxContainer/image
onready var speakerName := $Control/VBoxContainer/MarginContainer/panel/HBoxContainer/MarginContainer/VBoxContainer/name
onready var speakerText := $Control/VBoxContainer/MarginContainer/panel/HBoxContainer/MarginContainer/VBoxContainer/RichTextLabel
onready var speakerOptions := $Control/VBoxContainer/MarginContainer/panel/HBoxContainer/MarginContainer/VBoxContainer/options
onready var pressText := $Control/VBoxContainer/MarginContainer2/Label

onready var tween := $Tween

onready var button = preload("res://entities/player/HUD/classes/button/buttonDialog.tscn")

signal optionChosen(question, option)
signal newText(text)
signal dialogClosed
signal dialogOpened

var opened := false
var optionID := 0
var dialogQueue := []
var icons := []

func setup(dialogs : Array, images : Array):
	dialogQueue = dialogs
	icons = images

func open(dialogs : Array = dialogQueue, images : Array = icons):
	$Control.modulate = Color(1, 1, 1, 0)
	visible = true
	Global.player.moving = false
	dialogQueue.append_array(dialogs)
	icons = images
	_set_text()
	
	emit_signal("dialogOpened")
	tween.interpolate_property($Control, "modulate", Color(1, 1, 1, 0),
	Color.white, 0.15, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	opened = true
	pressText.visible = true

func _physics_process(_delta):
	if Input.is_action_just_pressed("interact"):
		if opened:
			interact()

func interact():
	
	if dialogQueue[0].options:
		emit_signal("optionChosen", dialogQueue[0].text, dialogQueue[0].options[optionID])
	
	dialogQueue.pop_at(0)
	if dialogQueue:
		_set_text()
	else:
		exit()

func _set_text():
	emit_signal("newText", dialogQueue[0].text)
	
	speakerText.bbcode_text = tr(dialogQueue[0].text).format(Global.save.player["playerProperties"])
	
	if dialogQueue[0].options:
		speakerOptions.visible = true
		
		var previousButton : Button
		
		for opt in range(dialogQueue[0].options.size()):
			var newOption = button.instance()
			newOption.text = tr(dialogQueue[0].options[opt])
			
			speakerOptions.add_child(newOption)
			
			if opt > 0:
				newOption.focus_neighbour_left = previousButton.get_path()
			
				previousButton.focus_neighbour_right = newOption.get_path()
			
			if opt == 0:
				newOption.grab_focus()
			
			previousButton = newOption
			
	else:
		speakerOptions.visible = false
	
	if dialogQueue[0].name != "":
		speakerName.visible = true
		speakerName.text = dialogQueue[0].name
	else:
		speakerName.visible = false
	
	if dialogQueue[0].imageId >= 0:
		speakerImage.visible = true
		speakerImage.texture["atlas"] = icons[dialogQueue[0].imageId]
		speakerImage.texture["region"].position.x = dialogQueue[0].react * 92
	else:
		speakerImage.visible = false
		speakerImage.texture["atlas"] = null

func exit():
	pressText.visible = false
	opened = false
	dialogQueue.clear()
	emit_signal("dialogClosed")
	
	tween.interpolate_property($Control, "modulate", rect["modulate"],
	Color(1, 1, 1, 0), 0.15, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	speakerOptions.visible = false
	speakerImage.visible = false
	speakerImage.texture["atlas"] = null
	speakerName.visible = false
	
	visible = false
	Global.player.moving = true
