extends NPCBase

onready var dialog := $dialog

var dialogs = [
	[
		Question.new("alex_8", ["alex_8_1", "alex_8_2"]),
	], 
	[
		{"name" : "Alex", "text" : "alex_9", "image": 0, "react" : 2},
		{"name" : "Alex", "text" : "alex_10"},
		{"name" : "Alex", "text" : "alex_11"},
		{"name" : "Alex", "text" : "alex_12"}
	]
]

var currentDialog := 0

func _ready():
	dialog.setup(dialogs[0])

func _on_dialog_optionChosen(_question, option):
	if option == "alex_9_1":
		dialog.addDialog(dialogs[1])
			
