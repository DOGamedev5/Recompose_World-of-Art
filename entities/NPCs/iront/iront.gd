extends KinematicBody2D

onready var dialog = $dialog

onready var textDialogs := [
	"Rodolfo- oh, sorry, Lodrofo!!!\nwhat do you want?",
	"you want to fight in the coliseun?!?!\noh ok, there is your sword.",
	preload("res://entities/NPCs/iront/irontQuestion.tres")
]

func enterEntity(area):
	if area.is_in_group("player"):
		dialog.activeded(area, textDialogs)
		
func exitEntity(area):
	if area.is_in_group("player"):
		dialog.desactiveded()
		
