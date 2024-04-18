extends Control

onready var options = $"../options"
onready var initial = $"../initial"
onready var saves = $"../saves"
onready var parent = $"../"

var current := false

func _on_buttonMenu_pressed():
	parent.transition(initial, [self, options, initial, saves])

func enter():
	$buttonMenu.active = true

func changed():
	$buttonMenu.active = false
