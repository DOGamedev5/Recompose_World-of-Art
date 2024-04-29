extends RoomClass

onready var dialog = $dialog

var player : PlayerBase

var dialogs = [
	{"image" : 1, "react" : 0, "text" : "fenico_1", "name" : "Fenico"},
	{"image" : 0, "react" : 1, "text" :  "fenico_2", "name" : "???"},
	{"image" : 1, "react" : 1, "text" : "fenico_3", "name" : "Fenico"},
	{"image" : 0, "react" : 2, "text" :  "fenico_4", "name" : "Lodrofo"},
	{"image" : 1, "react" : 4, "text" :  "fenico_5", "name" : "Fenico"},
	{"image" : 1, "react" : 2, "text" :  "fenico_6", "name" : "Fenico"},
	{"image" : 0, "react" : 1, "text" :  "fenico_7", "name" : "Lodrofo"},
	{"image" : 1, "react" : 2, "text" :  "fenico_8", "name" : "Fenico"},
	{"image" : 0, "react" : 1, "text" :  "fenico_9", "name" : "Lodrofo"},
	{"image" : 1, "react" : 1, "text" :  "fenico_10", "name" : "Fenico"},
	{"image" : 1, "react" : 5, "text" :  "fenico_11", "name" : "Fenico"},
	{"image" : 0, "react" : 0, "text" :  "fenico_12", "name" : "Lodrofo"},
	{"image" : 1, "react" : 0, "text" :  "fenico_13", "name" : "Fenico"},
]

func _ready():
	if not Global.save.played:
		player = get_parent().player
		player.setCutscene(true)
		player.fliped = true
		dialog.addDialog(dialogs)
		
		$AnimationPlayer.play("introdution")

func interact():
	dialog.interacted(player)

func _input(_event):
	if Input.is_action_just_pressed("interact") and not Global.save.played and dialog.hasInteracted:
		interact()

func _on_dialog_dialogClosed():
	player.setCutscene(false)
	Global.save.played = true
