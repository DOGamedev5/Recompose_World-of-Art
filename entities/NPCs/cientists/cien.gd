extends NPCBase

const dialog := [
	
	[
		{"text" : "cien_1", "name" : "cien", "image" : 0},
		{"text" : "cien_2", "name" : "cien", "image" : 0},
		{"text" : "cien_3", "name" : "Lodrofo", "image" : 1},
		{"text" : "cien_4", "name" : "cien", "image" : 0},
		{"text" : "cien_5", "name" : "Lodrofo", "image" : 1},
		{"text" : "cien_6", "name" : "cien", "image" : 0},
		{"text" : "cien_7", "name" : "Lodrofo", "image" : 1},
		{"text" : "cien_8", "name" : "cien", "image" : 0},
		{"text" : "cien_9", "name" : "cien", "image" : 0},
	],
	[
		{"text" : "cien_10", "name" : "cien", "image" : 0}
	]
]

var currentDialog = 0

func _ready():
	
	if Global.save.world["paintWorld"].has("cienTalked"):
		currentDialog = Global.save.world["paintWorld"]["cienTalked"]
		
	$dialog.setup(dialog[currentDialog])

func _on_dialog_dialogClosed():
	if currentDialog == 0:
		$dialog.setup(dialog[1])
		currentDialog = 1
		Global.save.world["paintWorld"]["cienTalked"] = 1
