extends Control

onready var options = $"../options"
onready var initial = $"../initial"
onready var parent = $"../"

var current := false

func _on_ExitSaves_pressed():
	parent.transition(initial, [self, options])


