class_name LevelClass extends Node2D

export(String, FILE, "*.tscn") var firstRoom := ""

var currentRoom : RoomClass
var currentRoomID := 0
var player

var currentWorld := "sandDesert"

var isOnDimension := false
var clock := false
onready var timer := Timer.new()

var background

var roomsToSave := {}
var dimensionsRooms := {}

var roomsData := {
	
}

var currentRoomInfo := {}

func _ready():
	timer.one_shot = true
	add_child(timer)
	Global.world = self
	var playerScene = LoadSystem.loadObject("res://entities/player/powerStates/normal/playerNormal.tscn")
	var playerHudScene = LoadSystem.loadObject("res://entities/player/HUD/playerHud.tscn")
	
	Global.playerHud = playerHudScene.instance()
	Global.get_parent().add_child(Global.playerHud)
	Global.player = playerScene.instance()
	add_child(Global.player)
	
	call_deferred("loadSave")
	
	AudioManager.playMusic("paintCaverns")

func _exit_tree():
	Global.playerHud.queue_free()

func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "player", "setCameraLimits", limitsMin, limitsMax)

func setupRoom(room):
	if currentRoom:
		currentRoom.queue_free()
#		saveDataRoom(Global.currentRoom.duplicate(true))
	
#	room = loadDataRoom(room)
	if currentWorld != room.world:
		currentWorld = room.world
		isOnDimension = room.world.get_base_dir() == "res://dimensions"
		
#		var backgroundScene = LoadSystem.loadObject("{0}/background.tscn".format([room.world]), false)
		var backgroundScene = load("{0}/background.tscn".format([room.world]))
		if background:
			background.queue_free()
		
		background = backgroundScene.instance()
		add_child(background)
	
#	var currentRoomScene  = LoadSystem.loadObject(room.roomPath, false)
	var currentRoomScene = load(room.roomPath)
	
	currentRoom = currentRoomScene.instance()
	
	add_child(currentRoom)
	
	Global.currentRoom = room
	currentRoomInfo = room

func loadSave():
	Global.player.active = false
	
	setupRoom(Global.currentRoom)
	
	Global.player.position = Global.save.player["position"]
	Global.player.set_deferred("active", true)
	
	LoadSystem.closeLoad()


func loadRoom(room):
	Global.player.transition.transitionIn()
	
	yield(Global.player.transition, "transitionedIn")
	
	setupRoom(room)

	currentRoom.init(room.warpID, room.warpType)

	Global.player.transition.call_deferred("transitionOut")
	Global.player.resetParticles()

func setupTimer(time):
	clock = true
	timer.wait_time = time
	timer.start()

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
	
#	room = loadDataRoom(room)
	
	return room

func addToRoomData(objName, type):
	var world := currentWorld.replace(currentRoom.get_base_dir()+"/", "")
	
	roomsData[currentWorld] = {}
	roomsData[currentWorld]["room{}".format(currentRoomInfo.ID)] = {}


func loadDataRoom(room):
	if room.world.get_base_dir() == "res://dimensions":
		if dimensionsRooms.has(room.ID):
			for key in dimensionsRooms[room.ID].data.keys():
				room.data[key] = Global.dimensionsRooms[room.ID].data[key]
		
	elif room.ID != 0:
		var roomPath : String = getRoomSave(room)
		
		if roomsToSave.has(roomPath):
			room.data = roomsToSave[roomPath].data
			
		elif FileSystemHandler.fileExist(roomPath):
			var data : Dictionary = FileSystemHandler.loadDataJSON(roomPath).data
			
			for key in data.keys():
				room.data[key] = data[key]
	
	return room

func saveDataRoom(room):
	verifyDirsRoom(room)

	if room.world.get_base_dir() == "res://dimensions":
		dimensionsRooms[room.ID] = room
		
		return
	
	if room.ID == 0: return

	roomsToSave[getRoomSave(room)] = room

func getRoomSave(room : Dictionary):
	if room.world.get_base_dir() != "res://dimensions" and room.category == "rooms":
		var saveWorldPath = Global.savePath + "worldRooms" + room.world.substr(12)  + "/rooms"
		
		return saveWorldPath + "/room{index}.json".format({"index" : room.ID})

func verifyDirsRoom(room):
	var dir := Directory.new()
	if dir.open(Global.savePath) != OK:
		dir.make_dir_recursive(Global.savePath)
		dir.open(Global.savePath)
	
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


