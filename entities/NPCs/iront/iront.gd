extends KinematicBody2D

onready var dialog = $dialog

onready var textDialogs := [
	"Rodolfo- oh, sorry, Lodrofo!!!\nwhat do you want?",
	"you want to fight in the coliseun?!?!\noh ok, there is your sword.",
	preload("res://entities/NPCs/iront/irontQuestion.tres")
]

func _ready():
	dialog.setup(textDialogs)
		
