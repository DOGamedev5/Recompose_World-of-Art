extends Control

onready var options = $"../options"
onready var saves = $"../saves"
onready var parent = $"../"

var current := true

func _on_start_pressed():
	parent.transition(saves, [self, options])

func _on_options_pressed():
	parent.transition(options, [self, saves])
