extends KinematicBody2D

onready var dialog = $dialog
onready var barrier = $StaticBody2D/CollisionShape2D

onready var textDialogs := [
	[
		"Rodolfo- oh, sorry, Lodrofo!!!\nwhat do you want?",
		"you want to fight in the coliseun?!?!\noh ok, there is your sword.",
		preload("res://entities/NPCs/iront/irontQuestion.tres")
	],
	[
		"hello Lodrofo, everthing going well?"
	]
]

func _ready():
	barrier.disabled = Global.save.world["paintWorld"]["colliseun"]
	
	if barrier.disabled:
		dialog.setup(textDialogs[1])
		position = Vector2(-208, -672)
	else:
		dialog.setup(textDialogs[0])
		position = Vector2(-1392, -224)

func optionChosen(question, option):
	if question == "do you want to enter the coliseum now?":
		if option == "Yes!":
			dialog.addText("ok fine, there is you sword")
			Global.save.world["paintWorld"]["colliseun"] = true
			barrier.disabled = true
