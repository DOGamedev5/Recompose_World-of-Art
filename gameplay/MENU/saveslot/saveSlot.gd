extends Node

export var saveID := 1

const dirSavePath = "user://userData/saves/save%d/"

onready var tween = $Tween
onready var buttons := [$VBoxContainer/play, $VBoxContainer/erase]

export var menuPath : NodePath
onready var menu = get_node(menuPath)

var save
var savePath : String

func _ready():
	savePath = dirSavePath % saveID
	
	Global.createFileData(savePath)
	
	$VBoxContainer/Label.text = "SAVE " + str(saveID)
	
	var _1 = $VBoxContainer/play.connect("pressed", self, "_on_Play_pressed")
	var _2 = $VBoxContainer/erase.connect("pressed", self, "_on_Erase_pressed")
	
	var data : SaveGame = Global.loadData(savePath + "save.tres")
	buttons[1].disatived = not data.played
	$VBoxContainer/name.text = data.player["playerProperties"]["name"]
	
	

func _on_Play_pressed():
	Global.loadGameData(savePath)
	
	LoadSystem.loadScene(menu, "res://worlds/main.tscn")

func _on_Erase_pressed():
	Global.saveData(savePath + "save.tres", SaveGame.new())
	Global.saveData(savePath + "roomData.tres", RoomData.new())
	buttons[1].disatived = true

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
