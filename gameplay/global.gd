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
var playerHud : PlayerHud
var roomsToSave := {}
var dimensionsRooms := {}

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

func saveGameData(position = null):
	Global.save.player["position"] = position if position else player.global_position
	Global.save.played = true
	
	saveData(savePath + "save.tres", save)
	saveData(savePath + "roomData.tres", currentRoom)
	
	for path in roomsToSave.keys():
		print(path)
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

func deleteFileData(path):
	var _Dir := Directory.new()
	deleteDirArchives(_Dir, path)

func deleteDirArchives(dir : Directory, path, deleteItself := false):
	if dir.open(path) == OK:
		var _1 = dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				deleteDirArchives(Directory.new(), path + file_name + "/", true) 
			else:
				var _2 = dir.remove(file_name)
			
			file_name = dir.get_next()
		
		if deleteItself:
			var _2 = dir.remove(path)
	
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

func bin_array(n : int, size := 8):
	var ret_array := []
	
	while n > 0:
		ret_array.insert(0, n&1)
		n = n>>1
	
	while ret_array.size() < size:
		ret_array.insert(0, 0)
	
	print(ret_array)
	return ret_array
