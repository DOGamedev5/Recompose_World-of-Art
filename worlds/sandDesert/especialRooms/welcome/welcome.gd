extends RoomClass

var dialogs = [
	[
		{"name" : "Alex", "text" : "alex_1", "image": 0, "react" : 1},
		{"name" : "Alex", "text" : "alex_2", "image": 0, "react" : 5},
		{"name" : "Alex", "text" : "alex_3", "image": 0, "react" : 0}
	],
	[
		{"name" : "Alex", "text" : "alex_4", "image": 0, "react" : 5},
		{"name" : "Alex", "text" : "alex_5", "image": 0, "react" : 4},
		{"name" : "Alex", "text" : "alex_5", "image": 0, "react" : 1},
		{"name" : "Alex", "text" : "alex_7", "image": 0, "react" : 5},
	],
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


func _ready():
	if not Global.save.played:
		$AnimationPlayer._setup(dialogs)
		$AnimationPlayer.play("hello")

