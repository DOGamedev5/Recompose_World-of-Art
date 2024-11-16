extends Control

onready var options = $"../options"
onready var saves = $"../saves"
onready var parent = $"../"
onready var credits = $"../credits"

var current := true

func _ready():

	enter()

func _on_start_pressed():
	parent.transition(saves, [self, options, credits])

func _on_options_pressed():
	parent.transition(options, [self, saves, credits])

func _on_credits_pressed():
	parent.transition(credits, [self, saves, options])

func enter():
	parent.current = self
	$MarginContainer/VBoxContainer2/VBoxContainer/start.grab_focus()

func changed():
	pass

func _on_exit_pressed():

	$"../confirmExit".trigger()

	
