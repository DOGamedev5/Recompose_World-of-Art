extends RoomClass

onready var tween = $Tween
onready var cinemaitc := $cinematic

var dialogs = [
	[
		TextDialog.new("histrorus_1-0", "histrorus", [],  0, 1),
		TextDialog.new("histrorus_1-1", "histrorus", [],  0, 0),
	],
	[
		TextDialog.new("histrorus_1-2", "histrorus", [],  0, 5),
		TextDialog.new("histrorus_1-3", "histrorus", [],  0, 0),
		TextDialog.new("histrorus_1-4", "histrorus", [],  0, 2),
	]
]

var currentHelloPart := 0
var extended := false

func _ready():
	if not Global.save.played:
		cinemaitc.setup(dialogs)
		cinemaitc.play("hello")
		Global.playerHud.dialog.connect("dialogClosed", self, "_on_dialog_dialogClosed")
		
func _input(_event):
	if Input.is_action_just_pressed("ui_accept") and $contract/Control/TextureRect/LineEdit.editable and $contract.visible:
		_on_LineEdit_text_entered($contract/Control/TextureRect/LineEdit.text)

func _on_dialog_dialogClosed():
	if currentHelloPart == 0:
		tween.interpolate_property($contract/Control/TextureRect, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.4, Tween.TRANS_CUBIC)
		tween.interpolate_property($contract/Control/ColorRect, "self_modulate",Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.4, Tween.TRANS_CUBIC)
		$contract.visible = true
		$contract/Control/TextureRect/LineEdit.grab_focus()
		tween.start()
		
	elif currentHelloPart == 1:
		cinemaitc._end()
		Global.save.played = true
		Global.playerHud.dialog.disconnect("dialogClosed", self, "_on_dialog_dialogClosed")

func _on_LineEdit_text_entered(new_text):
	if not new_text: return
	
	$contract/Control/TextureRect/LineEdit.editable = false
	Global.save.player["playerProperties"]["name"] = new_text
	
	tween.interpolate_property($contract/Control/TextureRect, "rect_scale", Vector2(1, 1), Vector2(0, 0),  0.4, Tween.TRANS_CUBIC)
	tween.interpolate_property($contract/Control/ColorRect, "self_modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.4, Tween.TRANS_CUBIC)
	tween.start()
	
	yield(tween, "tween_completed")
	
	$contract.visible = false
	cinemaitc.play("hello1")
	currentHelloPart += 1


