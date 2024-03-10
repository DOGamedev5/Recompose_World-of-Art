extends Control

onready var initial = $"../initial"
onready var saves = $"../saves"
onready var parent = $"../"
onready var buttons = {
	simpleLight = $Panel/VBoxContainer/simpleLight
}

const optionsSavePath = "res://gameplay/MENU/optionsSave.tres"

var optionsSave : Resource

var current := false

func _ready():
	optionsSave = load(optionsSavePath)
	Global.simpleLight = optionsSave.simpleLight
	buttons.simpleLight.pressed = optionsSave.simpleLight

func _on_exitOptions_pressed():
	parent.transition(initial, [self, saves])

func _on_simpleLight_toggled(button_pressed):
	Global.simpleLight = button_pressed
	optionsSave.simpleLight = button_pressed
	var _1 = ResourceSaver.save(optionsSavePath, optionsSave)
