extends Control

onready var options = $"../options"
onready var initial = $"../initial"
onready var parent = $"../"

onready var buttons := [$buttonMenu]
onready var saveSlots := [$HBoxContainer/saveSlot, $HBoxContainer/saveSlot2, $HBoxContainer/saveSlot3]

var current := false

func _on_ExitSaves_pressed():
	parent.transition(initial, [self, options])

func enter():
	$buttonMenu.active = true
	
	for save in saveSlots:
		save.enter()

func changed():
	$buttonMenu.active = false
	
	for save in saveSlots:
		save.changed()
