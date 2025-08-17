extends KinematicBody2D

onready var dialog = $dialog
onready var barrier = $StaticBody2D/CollisionShape2D

onready var textDialogs := [
	[
		{"name" : "iront","text" : "iront_1"},
		{"name" : "iront","text" : "iront_2"},
		preload("res://entities/NPCs/iront/irontQuestion.tres")
	],
	[
		{"name" : "iront","text" : "iront_4"}
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
	if question == "iront_3":
		if option == "iront_3_1":
			dialog.addText("iront_3_3")
			Global.save.world["paintWorld"]["colliseun"] = true
			barrier.disabled = true

func _on_dialog_dialogClosed():
	dialog.setup(textDialogs[int(barrier.disabled)])

