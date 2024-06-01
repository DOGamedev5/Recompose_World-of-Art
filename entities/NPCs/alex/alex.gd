extends NPCBase

onready var dialog := $dialog

var dialogs = [
	[
		{"name" : "Alex", "text" : "alex_1"},
		{"name" : "Alex", "text" : "alex_2"},
		{"name" : "Alex", "text" : "alex_3"}
	],
	[
		Question.new("alex_4", ["alex_4_1", "alex_4_2"]),
	],
	[
		{"name" : "Alex", "text" : "alex_5"},
		{"name" : "Alex", "text" : "alex_6"},
		{"name" : "Alex", "text" : "alex_7"},
		{"name" : "Alex", "text" : "alex_8"}
	],
	[
		Question.new("alex_9", ["alex_9_1", "alex_9_2"])
	], 
	[
		{"name" : "Alex", "text" : "alex_10"},
		{"name" : "Alex", "text" : "alex_11"},
		{"name" : "Alex", "text" : "alex_12"},
		{"name" : "Alex", "text" : "alex_13"}
	]
]

var currentDialog := 0

func _ready():
	dialog.setup(dialogs[0])

func _on_dialog_dialogClosed():
	if currentDialog < 3 and currentDialog != 1:
			
		currentDialog += 1
		dialog.setup(dialogs[currentDialog])
		

func _on_dialog_optionChosen(question, option):
	if question == "alex_4":
		if option == "alex_4_1":
			currentDialog += 1
			dialog.addDialog(dialogs[2])
			dialog.addDialog(dialogs[3])
	
	if question == "alex_9":
		if option == "alex_9_1":
			dialog.addDialog(dialogs[4])
			
