extends Control

onready var initial = $"../initial"
onready var saves = $"../saves"

var current := false

func _process(_delta):
	visible = current

func _on_exitOptions_pressed():
	current = false
	initial.current = true
	saves.current = false

func _on_simpleLight_toggled(button_pressed):
	Global.simpleLight = button_pressed
