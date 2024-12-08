extends Node

const optionsSavePath = "user://options.tres"

onready var player : PlayerBase
onready var playerHud : PlayerHud
onready var languagesID : Array
onready var in_game := false

var options : OptionsSave

var save : SaveGame
var savePath : String
var world : LevelClass
var worldData : Dictionary
var currentWorldName := "sandDesert"
var worldDataSetup := false
var waintingToChange := false
var changingInfo := {}

signal simpleLightChanged(value)
signal shadowsChanged(value)

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	
	var _dir := Directory.new()
	
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

func changeWorld(catergory : String, newWorld : String, warpID := -1, warpType := ""):
#	get_tree().paused = true
	waintingToChange = true
	LoadSystem.openScreen()
	currentWorldName = newWorld
	
	if warpID >= 0:
		changingInfo.warpID = warpID
		changingInfo.warpType = warpType
	
	LoadSystem.addToQueueChangeScene("res://{catergory}/{world}/world.tscn".format({
		"catergory" : catergory,
		"world" : newWorld
	}))

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < tolerance

func _setSimpleLight(value):
	emit_signal("simpleLightChanged", value)
	options.simpleLight = value

func _setShadow(value):
	emit_signal("shadowsChanged", value)
	options.shadows = value

func addToRoomData(roomID : int, obj_name : String, catergory : String):
	if not worldData.has(currentWorldName):
		worldData[currentWorldName] = {}
	
	if not worldData[currentWorldName].has(str(roomID)):
		worldData[currentWorldName][str(roomID)] = {}
	
	if not worldData[currentWorldName][str(roomID)].has(catergory):
		worldData[currentWorldName][str(roomID)][catergory] = []
	
	worldData[currentWorldName][str(roomID)][catergory].append(obj_name)

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
	
	
