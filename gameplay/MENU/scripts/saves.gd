extends Control

onready var options = $"../options"
onready var initial = $"../initial"

var current := false

func _process(_delta):
	visible = current

func _on_ExitSaves_pressed():
	current = false
	initial.current = true
	options.current = false

