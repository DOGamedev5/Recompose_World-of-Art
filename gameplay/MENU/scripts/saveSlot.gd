extends Node

export var saveID := 1

const dirSavePath = "user://save%d"

onready var tween = $Tween

export var menuPath : NodePath
onready var menu = get_node(menuPath)

var save
var savePath

onready var room := preload("res://worlds/paintWorld/level1.tscn")

func _ready():
	
	savePath = "user://save%d.tres" % saveID
	if not Global.saveExist(savePath):
		Global.saveGameData(savePath, SaveGame.new())
	
	$VBoxContainer/Label.text = "SAVE " + str(saveID)
	
	var _1 = $VBoxContainer/play.connect("pressed", self, "_on_Play_pressed")
	var _2 = $VBoxContainer/erase.connect("pressed", self, "_on_Erase_pressed")

func _on_Play_pressed():
	Global.loadGameData(savePath)
	
	LoadSystem.loadScene(menu, "res://worlds/paintWorld/level1.tscn")

func _on_Erase_pressed():
	Global.saveGameData(savePath, SaveGame.new())

func visibility_changed():
	if self.visible:
		tween.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.8,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(0, 0), 0.8,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	
	tween.start()
