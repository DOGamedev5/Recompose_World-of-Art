extends Node

var options : OptionsSave

var save : SaveGame
var savePath : String
var _file := File.new()

signal simpleLightChanged(value)

func _ready():
	var _1 = connect("simpleLightChanged", self, "_setSimpleLight")	


func _setterSimpleLight(value):
	options.options.simpleLight = value
	emit_signal("simpleLightChanged", value)

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < tolerance

func _input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func setupPlayer(player):
	player.position = save.player["position"]

func _setSimpleLight(value):
	
	options.simpleLight = value

func saveExist(dataPath):
	return _file.file_exists(dataPath)

func saveGameData(dataPath, data : SaveGame):
	saveData(dataPath, data)

func loadGameData(dataPath):
	save = loadData(dataPath)
	savePath = dataPath

func saveData(dataPath, data : SaveBase):
	var _1 = ResourceSaver.save(dataPath, data)

func loadData(dataPath):
	return ResourceLoader.load(dataPath, "", true)

