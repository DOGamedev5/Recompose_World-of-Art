extends Node

const optionsSavePath = "user://options.tres"

onready var player :PlayerBase
onready var languagesID : Array

var options : OptionsSave

var save : SaveGame
var savePath : String
var _file := File.new()
var _dir := Directory.new()
var gamePaused := false setget setGamePause
var currentRoom 
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
		
	if not FileSystemHandler.fileExist(optionsSavePath):
		FileSystemHandler.saveDataResource(optionsSavePath, OptionsSave.new())
		
	options = FileSystemHandler.loadDataResource(Global.optionsSavePath)
	
	setup_langueges()
	
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

func setup_langueges():
	if not options.lang:
		options.lang = TranslationServer.get_locale()
		FileSystemHandler.saveDataResource(Global.optionsSavePath, Global.options)
	else:
		TranslationServer.set_locale(options.lang)
	
	for locale in TranslationServer.get_loaded_locales():
		if languagesID.has(locale): continue
		
		languagesID.append(locale) 

func set_languege(index):
	var locale : String = languagesID[index]
	
	TranslationServer.set_locale(locale)
	options.lang = TranslationServer.get_locale()
	FileSystemHandler.saveData(optionsSavePath, options)

func bin_array(n : int, size := 8):
	var ret_array := []
	
	while n > 0:
		ret_array.insert(0, n&1)
		n = n>>1
	
	while ret_array.size() < size:
		ret_array.insert(0, 0)
	
	print(ret_array)
	return ret_array

func generateRoomData(roomID := 0, worldPath : String = "res://worlds/sandDesert", Category : String = "rooms", path := "res://worlds/sandDesert/especialRooms/welcome/welcome.tscn", WarpID := 0, WarpType := "warp", debug := false):
	if roomID != 0:
		path = "{world}/{category}/room{room}.tscn".format({
			"world" : worldPath,
			"category" : Category,
			"room" : roomID
		})
	
	var room := {
		ID = roomID,
		world = worldPath,
		category = Category,
		roomPath = path,
		warpID = WarpID,
		warpType = WarpType,
		debugMode = debug,
		data = {
			"destroiedBlocks" : [],
			"collectedCoins" : []
		}
	}
	
	room = loadDataRoom(room)
	
	return room

func loadDataRoom(room):
	if room.world.get_base_dir() == "res://dimensions":
		if dimensionsRooms.has(room.ID):
			for key in dimensionsRooms[room.ID].data.keys():
				room.data[key] = Global.dimensionsRooms[room.ID].data[key]
		
	elif room.ID != 0:
		var roomPath : String = getRoomSave(room)
		
		if roomsToSave.has(savePath):
			room.data = Global.roomsToSave[roomPath].data
			
		elif FileSystemHandler.fileExist(savePath):
			var data : Dictionary = FileSystemHandler.loadDataJSON(roomPath).data
			
			for key in data.keys():
				room.data[key] = data[key]
	
	return room

func saveDataRoom(room):
	verifyDirsRoom(room)

	if room.world.get_base_dir() == "res://dimensions":
		Global.dimensionsRooms[room.ID] = room
		
		return
	
	if room.ID == 0: return
	
	var path : String = "worldRooms/"+ room.world.substr(13) + "/rooms/"

	roomsToSave[path + "room{0}.tres".format([room.ID])] = room

func getRoomSave(room : Dictionary):
	if room.world.get_base_dir() != "res://dimensions" and room.category == "rooms":
		var saveWorldPath = Global.savePath + "worldRooms" + room.world.substr(12)  + "/rooms"
		
		return saveWorldPath + "/room{index}.tres".format({"index" : room.ID})

func verifyDirsRoom(room):
	var dir := Directory.new()
	if dir.open(savePath) != OK:
		return
	
	for item in ["worldRooms", room.world.substr(13), "rooms"]:
		if room.world.get_base_dir() == "res://dimensions":
			break
		
		if not dir.dir_exists(item):
			var ERROR := dir.make_dir(item)
			if ERROR:
				print_debug("making {world} path gives the error: {error}".format(
					{"world" : item, "error" : ERROR})
				)
				break
		
		dir.change_dir(item)
