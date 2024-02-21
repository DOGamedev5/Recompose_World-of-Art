extends Control

onready var options = $"../options"
onready var saves = $"../saves"



var current := true

func _process(_delta):
	visible = current

func _on_start_pressed():
	current = false
	options.current = false
	saves.current = true

func _on_options_pressed():
	current = false
	options.current = true
	saves.current = false
