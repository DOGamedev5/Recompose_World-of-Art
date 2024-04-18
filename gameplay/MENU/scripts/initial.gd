extends Control

onready var options = $"../options"
onready var saves = $"../saves"
onready var parent = $"../"
onready var credits = $"../Credits"

onready var buttons := [$VBoxContainer/start, $VBoxContainer/options, $VBoxContainer/credits]

var current := true

func _on_start_pressed():
	parent.transition(saves, [self, options, credits])

func _on_options_pressed():
	parent.transition(options, [self, saves, credits])

func _on_credits_pressed():
	parent.transition(credits, [self, saves, options])


func enter():
	for button in buttons:
		button.active = true

func changed():
	for button in buttons:
		button.active = false
