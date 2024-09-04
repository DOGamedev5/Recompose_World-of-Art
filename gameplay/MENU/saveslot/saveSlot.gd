extends Node

export var saveID := 1

const dirSavePath = "user://userData/saves/save%d/"

onready var tween = $Tween
onready var buttons := [$VBoxContainer/play, $VBoxContainer/erase]

export var menuPath : NodePath
onready var menu = get_node(menuPath)

var savePath : String

func _ready():
	savePath = dirSavePath % saveID
	
	$VBoxContainer/Label.text = "SAVE " + str(saveID)
	
	var _1 = $VBoxContainer/play.connect("pressed", self, "_on_Play_pressed")
	var _2 = $VBoxContainer/erase.connect("pressed", self, "_on_Erase_pressed")
	
	var _dir = Directory.new()
	
	buttons[1].disatived = not _dir.file_exists(savePath + "save.tres")
	if not buttons[1].disatived:
		var data = Global.loadData(savePath+"save.tres")
		$VBoxContainer/name.text = data.player["playerProperties"]["name"]

func _on_Play_pressed():
	Global.createFileData(savePath)
	Global.loadGameData(savePath)
	
	LoadSystem.loadScene(menu, "res://worlds/main.tscn")

func _on_Erase_pressed():
	Global.deleteFileData(savePath)
	buttons[1].disatived = true
	$VBoxContainer/name.text = ""

func visibility_changed():
	if self.visible:
		tween.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.8,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(0, 0), 0.8,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	
	tween.start()

func enter():
	for button in buttons:
		button.active = true

func changed():
	for button in buttons:
		button.active = false
