extends RoomClass

onready var tween = $Tween

var dialogs = [
	[
		{"name" : "Alex", "text" : "alex_1", "image": 0, "react" : 1},
		{"name" : "Alex", "text" : "alex_2", "image": 0, "react" : 5},
		{"name" : "Alex", "text" : "alex_3", "image": 0, "react" : 0}
	],
	[
		{"name" : "Alex", "text" : "alex_4", "image": 0, "react" : 5},
		{"name" : "Alex", "text" : "alex_5", "image": 0, "react" : 4},
		{"name" : "Alex", "text" : "alex_6", "image": 0, "react" : 1},
		{"name" : "Alex", "text" : "alex_7", "image": 0, "react" : 5},
		Question.new("alex_8", ["alex_8_1", "alex_8_2"]),
	],
	[
		{"name" : "Alex", "text" : "alex_9", "image": 0, "react" : 2},
		{"name" : "Alex", "text" : "alex_10"},
		{"name" : "Alex", "text" : "alex_11"},
		{"name" : "Alex", "text" : "alex_12"}
	],
]

var currentHelloPart := 0
var extended := false

func _ready():
	if not Global.save.played:
		$AnimationPlayer._setup(dialogs)
		$AnimationPlayer.play("hello")

func _on_dialog_dialogClosed():
	
	if currentHelloPart == 0:
		tween.interpolate_property($contract/Control/TextureRect, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.4, Tween.TRANS_CUBIC)
		tween.interpolate_property($contract/Control/ColorRect, "self_modulate",Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.4, Tween.TRANS_CUBIC)
		$contract.visible = true
		tween.start()
		
	elif currentHelloPart == 1 and not extended:
		$AnimationPlayer._end()
	
	elif currentHelloPart == 2:
		$AnimationPlayer._end()

func _on_LineEdit_text_entered(new_text):
	if not new_text: return
	
	$contract/Control/TextureRect/LineEdit.editable = false
	Global.save.player["playerProperties"]["name"] = new_text
	
	tween.interpolate_property($contract/Control/TextureRect, "rect_scale", Vector2(1, 1), Vector2(0, 0),  0.4, Tween.TRANS_CUBIC)
	tween.interpolate_property($contract/Control/ColorRect, "self_modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.4, Tween.TRANS_CUBIC)
	tween.start()
	
	yield(tween, "tween_completed")
	
	$contract.visible = false
	$AnimationPlayer.play("hello1")
	currentHelloPart += 1


func _on_dialog_optionChosen(_question, option):
	if option == "alex_8_1":
		$dialog.addDialog(dialogs[2])
		currentHelloPart += 1
		extended = true
	else:
		$AnimationPlayer._end()
