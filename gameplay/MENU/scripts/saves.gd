extends Control

onready var options = $"../options"
onready var initial = $"../initial"
onready var parent = $"../"

var current := false


func enter():
	for child in $MarginContainer/VBoxContainer/HBoxContainer.get_children():
		if child.pressed:
			child.grab_focus()
			return
	
	$MarginContainer/VBoxContainer/HBoxContainer/contract.grab_focus()
	$MarginContainer/VBoxContainer/HBoxContainer/contract.pressed = true

func changed():
	pass

func _on_exit_pressed():
	parent.transition(initial, [self, options])

func _on_start_pressed():
	get_tree().root.set_disable_input(true)
	for child in $MarginContainer/VBoxContainer/HBoxContainer.get_children():
		if child.pressed:
			child.confirmed()
			return

func _on_erase_pressed():

	for child in $MarginContainer/VBoxContainer/HBoxContainer.get_children():
		if child.pressed:
			child.deleted()
			return
