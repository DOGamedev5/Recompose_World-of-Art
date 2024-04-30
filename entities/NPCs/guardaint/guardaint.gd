extends NPCBase

var dialogs = [
	[
		{"name" : "Guardaint","text" : "guardaint_1" },
		{"name" : "Guardaint","text" : "guardaint_2" }
	],
	[
		{"name" : "Guardaint","text" : "guardaint_3" },
		{"name" : "Guardaint","text" : "guardaint_4" }
	],
	[
		{"name" : "Guardaint","text" : "guardaint_5" }
	]
]

func _ready():
	$dialog.addDialog(dialogs[0])
