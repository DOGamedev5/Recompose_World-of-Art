extends Node

const optionsSavePath = "user://options.tres"

onready var player :PlayerBase

var options : OptionsSave

var save : SaveGame
var savePath : String
var _file := File.new()
var _dir := Directory.new()
var gamePaused := false setget setGamePause
var currentRoom : RoomData
var world : LevelClass
var lightThread : Thread

signal simpleLightChanged(value)
signal gamePaused
signal gameUnpaused


func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	var _1 = connect("simpleLightChanged", self, "_setSimpleLight")	
	if not saveExist(optionsSavePath):
		saveData(optionsSavePath, OptionsSave.new())
	
	options = loadData(Global.optionsSavePath)
	
func _input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func setGamePause(value):
	gamePaused = value
	
	if value == true:
		emit_signal("gamePaused")
	else:
		emit_signal("gameUnpaused")

func _setterSimpleLight(value):
	options.options.simpleLight = value
	emit_signal("simpleLightChanged", value)

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < tolerance

func _setSimpleLight(value):
	
	options.simpleLight = value

func saveExist(dataPath):
	return _file.file_exists(dataPath)

func saveGameData(dataPath, data : SaveGame):
	saveData(dataPath, data)

func loadGameData(dataPath):
	save = loadData(dataPath)
	
	currentRoom = save.world["currentRoom"]
	
	savePath = dataPath

func saveData(dataPath, data : Resource):
	var _1 = ResourceSaver.save(dataPath, data)

func loadData(dataPath):
	return ResourceLoader.load(dataPath, "", true)


