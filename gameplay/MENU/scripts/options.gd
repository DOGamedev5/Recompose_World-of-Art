extends Control

onready var initial = $"../initial"
onready var saves = $"../saves"
onready var parent = $"../"
onready var buttons = {
	simpleLight = $Panel/VBoxContainer/HBoxContainer/CheckButton
}

const optionsSavePath = "user://options.tres"

var optionsSave := OptionsSave.new()

var current := false

func _ready():
	if not Global.saveExist(optionsSavePath):
		Global.saveData(optionsSavePath, OptionsSave.new())
	
	Global.options = Global.loadData(optionsSavePath)
	
	optionsSave = Global.options
	buttons.simpleLight.pressed = Global.options.simpleLight

func _on_exitOptions_pressed():
	parent.transition(initial, [self, saves])

func _on_simpleLight_toggled(button_pressed):
	Global.options.simpleLight = button_pressed
	optionsSave.simpleLight = button_pressed
	Global.saveData(optionsSavePath, optionsSave) 
