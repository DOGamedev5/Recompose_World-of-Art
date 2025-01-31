extends Node

const optionsSavePath = "user://options.tres"

onready var tree := get_tree()
onready var player : PlayerBase
onready var packedPlayer : PackedScene
onready var playerHud : PlayerHud
onready var languagesID : Array
onready var in_game := false
onready var inputEnabled := true
onready var changingInfo := {
	warpType = "warp",
	warpID = 0
}

var options : OptionsSave

var save : SaveGame
var savePath : String
var world : LevelClass
var worldData : Dictionary
var currentWorldName := "sandDesert"
var worldDataSetup := false
var waintingToChange := false

var time := OS.get_unix_time()

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
	call_deferred("updateActivity")

func updateActivity() -> void:
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_state("playing")

	var assets = activity.get_assets()
	assets.set_large_image("large")
	assets.set_large_text("RECOMPOSE: World of Art")

	var timestamps = activity.get_timestamps()
	timestamps.set_start(time)
	
	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
		push_error(str(result))
		
func _input(_event):
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func handInput(action : String, pressed := false) -> bool:
	if not inputEnabled:
		return false
	elif pressed:
		return Input.is_action_pressed(action)

	return Input.is_action_just_pressed(action)

func handInputAxis(actionA, actionB) -> float:
	if not inputEnabled:
		return 0.0
	
	return Input.get_axis(actionA, actionB)

func changeWorld(catergory : String, newWorld : String, warpID := -1, warpType := ""):
	
	packedPlayer = PackedScene.new()
	packedPlayer.pack(player) 
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
	options.simpleLight = value
	tree.call_group("light", "_toggledSimpleLight", value)

func _setShadow(value):
	options.shadows = value
	tree.call_group("shadow", "_toggledShadow", value)

func _setColorEffect(value):
	options.colorEffect = value
	tree.set_group("color", "visible", value)

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
	
	return ret_array

func disableInput(value):
	tree.call_group("input", "set_process_input", value)
	

