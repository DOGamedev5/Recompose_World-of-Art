extends Node

export var saveID := 1
var save
var savePath

onready var room := preload("res://worlds/paintWorld/level1.tscn")

func _ready():
	savePath = "res://gameplay/saves/data/save%d/save.tres" % saveID
	save = load(savePath)
	$VBoxContainer/Label.text = "SAVE " + str(saveID)
	
	var _1 = $VBoxContainer/play.connect("pressed", self, "_on_Play_pressed")
	var _2 = $VBoxContainer/erase.connect("pressed", self, "_on_Erase_pressed")
	
	

func _on_Play_pressed():
	Global.save = save
	Global.savePath = savePath
	var _1 = get_tree().change_scene_to(room)

func _on_Erase_pressed():
	var emptySlot = SaveResource.new()
	
	save = emptySlot
	ResourceSaver.save(savePath, save)



