extends NPCBase

onready var blockPass = $StaticBody2D/CollisionShape2D

var dialogs = [
	[
		{"name" : "guardaint","text" : "guardaint_1" },
		{"name" : "guardaint","text" : "guardaint_2" }
	],
	[
		{"name" : "guardaint","text" : "guardaint_3" },
		{"name" : "guardaint","text" : "guardaint_4" }
	],
	[
		{"name" : "guardaint","text" : "guardaint_5" }
	]
]

var currentDialog := 0

func _ready():
	$dialog.setup(dialogs[0])

	if Global.save.world["paintWorld"].has("guardaintTalked") and Global.save.world["paintWorld"]["guardaintTalked"]:
		$dialog.setup(dialogs[2])
		blockPass.disabled = true
	
	elif Global.save.world["paintWorld"].has("metaint") and Global.save.world["paintWorld"]["metaint"] == true:
		$dialog.setup(dialogs[1])
		currentDialog = 1

func _on_dialog_dialogClosed():
	if currentDialog == 1:
		Global.save.world["paintWorld"]["guardaintTalked"] = true
		$dialog.setup(dialogs[2])
		currentDialog = 2
		blockPass.disabled = true
