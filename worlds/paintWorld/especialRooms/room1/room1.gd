extends RoomClass

onready var dialog = $dialog

var player : PlayerBase

var dialogs = [
	{"image" : 1, "text" : "Hello, king, its me [color=red]Fenico"},
	{"image" : 0, "react" : 1, "text" : "what... hey? king?!?!"},
	{"image" : 1, "text" : "yeah, king, its me, your loyal sublord, I only could get one fragment of your soul"},
	{"image" : 0, "react" : 2, "text" : "[shake radius = 10 freq = 4] WHAT? [/shake] I dont get it, king? my name is... [wave]is...[/wave] Lodrofo?"},
	{"image" : 1, "text" : "Yes! King Lodrofo, you remenbered your name, maybe you lost you memories, since that you only have one fragment of your soul, so I'll tell you what happened"},
	{"image" : 1, "text" : "the Sublords, they betrayed you, but some of then, like me, remained loyal to you"},
	{"image" : 0, "react" : 1, "text" : "how am I going to recover the rest of my soul?"},
	{"image" : 1, "text" : "everthing I know is that the sublords stored the fragments in various dimensions, such as are scattered throughout the kingdom."},
	{"image" : 0, "react" : 1, "text" : "why didn't they... just destroyed them?"},
	{"image" : 1, "text" : "is not possible to destroy them"}
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
