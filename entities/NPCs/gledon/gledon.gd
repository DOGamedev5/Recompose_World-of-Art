extends NPCBase

onready var dialog = $dialog

var dialogs := [
	[
		{"name" : "Gledon", "text" : "gledon_1"},
		{"name" : "Gledon", "text" : "gledon_2"},
	]
]


func _ready():
	dialog.setup(dialogs[0])
