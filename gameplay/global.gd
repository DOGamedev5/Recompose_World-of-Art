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
var playerHud
var roomsToSave := {}

signal simpleLightChanged(value)
signal shadowsChanged(value)
signal gamePaused
signal gameUnpaused

func _ready():
	pause_mode = PAUSE_MODE_PROCESS

	if not _dir.dir_exists("user://userData"):
		var _2 = _dir.make_dir("user://userData")
	
	if not _dir.dir_exists("user://userData/saves"):
		var _2 = _dir.make_dir("user://userData/saves")
		
	if not saveExist(optionsSavePath):
		saveData(optionsSavePath, OptionsSave.new())
		
	options = loadData(Global.optionsSavePath)
	
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

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < tolerance

func _setSimpleLight(value):
	emit_signal("simpleLightChanged", value)
	options.simpleLight = value

func _setShadow(value):
	emit_signal("shadowsChanged", value)
	options.shadows = value

func saveExist(dataPath):
	return _file.file_exists(dataPath)

func loadGameData(dataPath):
	save = loadData(dataPath + "save.tres")
	
	currentRoom = loadData(dataPath + "roomData.tres")
	
	savePath = dataPath

func saveGameData():
	saveData(savePath + "save.tres", save)
	saveData(savePath + "roomData.tres", currentRoom)
	
	for path in roomsToSave.keys():
		saveData(path, roomsToSave[path])

func saveData(dataPath, data : Resource):
	var _1 = ResourceSaver.save(dataPath, data)

func createFileData(path):
	var _error := _dir.make_dir_recursive(path + "/worldRooms")
	
	if not saveExist(path + "save.tres"):
		saveData(path + "save.tres", SaveGame.new())
		saveData(path + "roomData.tres", RoomData.new())
		
	elif not saveExist(path + "roomData.tres"):
		saveData(path + "roomData.tres", RoomData.new())
	
	
func loadData(dataPath):
	return ResourceLoader.load(dataPath, "", true)

func changePlayer(powerUp):
	var position : Vector2 = Global.player.global_position
	player.queue_free()
	player = load(powerUp).instance()

	world.call_deferred("add_child", Global.player)
	player.set_deferred("global_position", position)

	world.player = Global.player

func addToRoomData(obj_name : String, catergory : String):
	if not obj_name in currentRoom.data[catergory]:
		currentRoom.data[catergory].append(obj_name)
