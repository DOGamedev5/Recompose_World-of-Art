extends RoomClass

onready var dialog = $dialog

var player : PlayerBase

var dialogs = [
	{"image" : 1, "react" : 0, "text" : "fenico_1", "name" : "fenico"},
	{"image" : 0, "react" : 1, "text" :  "fenico_2", "name" : "???"},
	{"image" : 1, "react" : 1, "text" : "fenico_3", "name" : "fenico"},
	{"image" : 0, "react" : 2, "text" :  "fenico_4", "name" : "Lodrofo"},
	{"image" : 1, "react" : 4, "text" :  "fenico_5", "name" : "fenico"},
	{"image" : 0, "react" : 2, "text" :  "fenico_6", "name" : "Lodrofo"},
	{"image" : 1, "react" : 2, "text" :  "fenico_7", "name" : "fenico"},
	{"image" : 0, "react" : 2, "text" :  "fenico_8", "name" : "Lodrofo"},
	{"image" : 1, "react" : 1, "text" :  "fenico_9", "name" : "fenico"},

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
