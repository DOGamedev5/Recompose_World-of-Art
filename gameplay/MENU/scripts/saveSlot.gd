extends Node

export var saveID := 1

const dirSavePath = "res://gameplay/saves/data/save%d"

var save
var savePath

onready var room := preload("res://worlds/paintWorld/level1.tscn")

func _ready():
	savePath = "res://gameplay/saves/data/save%d/save.tres" % saveID
	
	if ResourceLoader.exists(savePath):
		save = load(savePath)
		print("aaaa")
	
	else:
		var dir := Directory.new()
		save = SaveResource.new()
		
		if not dir.dir_exists(dirSavePath % saveID):
			var _1 = dir.make_dir(dirSavePath % saveID)
			
		ResourceSaver.save(savePath, save)
		print("bbbb")
		
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
	var _1 = ResourceSaver.save(savePath, save)



