extends Node

const optionsSavePath = "user://options.tres"

onready var tree := get_tree()
onready var player : Node
onready var packedPlayer : PackedScene
onready var playerHud : Node
onready var languagesID : Array
onready var in_game := false
onready var inputEnabled := true
onready var changingInfo := {
	warpType = "warp",
	warpID = 0
}
onready var inputAction := {
	"ui_left" : 0.0,
	"ui_right" : 0.0,
	"ui_up" : 0.0,
	"ui_down" : 0.0,
	"interact" : 0.0,
	"ui_accept" : 0.0,
	"ui_jump" : 0.0,
	"ui_enter" : 0.0,
	"run" : 0.0,
	"attack" : 0.0,
	"confirm" : 0.0
}

enum plataforms {
	STEAM,
	ITCHIO
}

var options : OptionsSave

var save : SaveGame
var savePath : String
var world : Node
var worldData : Dictionary
var currentWorldName := "sandDesert"
var worldDataSetup := false
var waintingToChange := false

var time := OS.get_unix_time()

onready var cmdargs := {
	connectLobby = false
}

puppetsync var chat := PoolStringArray([])

func _ready():
	setup()
	
	pause_mode = PAUSE_MODE_PROCESS
	
	var _dir := Directory.new()
	
	if not _dir.dir_exists("user://userData"):
		var _2 = _dir.make_dir("user://userData")
	
	if not _dir.dir_exists("user://userData/saves"):
		var _2 = _dir.make_dir("user://userData/saves")
		
	if not FileSystemHandler.fileExist(optionsSavePath):
		FileSystemHandler.saveDataResource(optionsSavePath, OptionsSave.new())
		
	options = FileSystemHandler.loadDataResource(optionsSavePath)
	
	setup_langueges()
	call_deferred("updateActivity")
	
	checkCommandLine()

func _process(_delta):
	Steam.run_callbacks()

func checkCommandLine() -> void:
	for ARG in OS.get_cmdline_args():
		if ARG == "+connect_lobby":
			cmdargs.connectLobby = true

func setup():
	var initialize_response: Dictionary = Steam.steamInitEx(480, false)
	print("Did Steam initialize?: %s" % initialize_response)

	if initialize_response['status'] > Steam.STEAM_API_INIT_RESULT_OK:
		push_error("Failed to initialize Steam, shutting down: %s" % initialize_response)
		if ProjectSettings["global/plataform"] == plataforms.STEAM:
			get_tree().quit()
		return

func sendMessagge(message : String, sender : int = -1):
	if not message.ends_with("\n"):
		message += "\n"
	
	if sender == -1:
		chat.append(message)
	else:
		message = message.replace("[", "[lb]")
		chat.append("[color=yellow]{id}:[/color] {message}".format({"message" : message, "id" : "{"+str(sender)+"}"}))
	
	if chat.size() > 40:
		chat.remove(0)

func updateActivity() -> void:
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_state("playing")

	var assets = activity.get_assets()
	assets.set_large_image("large")

	var timestamps = activity.get_timestamps()
	timestamps.set_start(time)
	assets.set_large_text("RECOMPOSE: World of Art")
	
	var result = yield(Discord.activity_manager.update_activity(activity), "result").result
	if result != Discord.Result.Ok:
		push_error(str(result))
		
func _input(_event):
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func handInput(action : String, pressed := false, ownerID := Network.steamID) -> bool:
	if not Network.is_owned(ownerID): return false
	if not inputEnabled:
		if inputAction.has(action):
			return inputAction[action] != 0
		
		return false
	else:
		if inputAction.has(action):
			inputAction[action] = 0.0
			
	if pressed: return Input.is_action_pressed(action)

	return Input.is_action_just_pressed(action)

func handInputAxis(actionA : String, actionB : String, ownerID := Network.steamID) -> float:
	if not Network.is_owned(ownerID): return 0.0
	if not inputEnabled:
		var result := 0.0
		if inputAction.has(actionA):
			result -= inputAction[actionA]
			
		if inputAction.has(actionB):
			result += inputAction[actionB]
		
		return result
	else:
		if inputAction.has(actionA):
			inputAction[actionA] = 0.0
		if inputAction.has(actionB):
			inputAction[actionB] = 0.0
	
	return Input.get_axis(actionA, actionB)

func setInput(action : String, press : float, ownerID := Network.steamID):
	if not Network.is_owned(ownerID): return
	if inputAction.has(action):
		inputAction[action] = press

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
		FileSystemHandler.saveDataResource(optionsSavePath, options)
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
	
func setTimeMultiply(multiply : float, timer = 0.2):
	Engine.time_scale = multiply

	if multiply != 1:
		tree.create_timer(timer*multiply).connect("timeout", self, "setTimeMultiply", [1.0])

