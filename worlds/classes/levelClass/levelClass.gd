class_name LevelClass extends Node2D

export(String, FILE, "*.tscn") var firstRoom := ""

signal changedRoom

var currentRoom
var currentRoomID := 0
var player

var currentWorld := "sandDesert"

var background

func _ready():
	Global.world = self
	var playerScene = LoadSystem.loadObject("res://entities/player/powerStates/normal/playerNormal.tscn")
#	var playerScene = LoadSystem.loadObject("res://entities/player/powerStates/book/playerBook.tscn")
	
	player = playerScene.instance()
	add_child(player)
	
	call_deferred("loadSave")
	
	AudioManager.playMusic("paintCaverns")
	
	
func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "player", "setCameraLimits", limitsMin, limitsMax)

func loadSave():
	player.active = false
	
	saveDataRoom()
	
	var currentRoomScene = LoadSystem.loadObject(Global.currentRoom.roomPath)
	
	var backgroundScene = LoadSystem.loadObject("{0}/background.tscn".format([Global.currentRoom.world]))
	
	background = backgroundScene.instance()
	currentRoom = currentRoomScene.instance()
	
	add_child(background)
	call_deferred("add_child", currentRoom)
	
	player.position = Global.save.player["position"]
	
	player.set_deferred("active", true)
	
	LoadSystem.closeLoad()


func loadRoom(room : RoomData):
	player.transition.transitionIn()
	
	yield(player.transition, "transitionedIn")
	emit_signal("changedRoom")
	
	if currentRoom:
		currentRoom.queue_free()
	
	saveDataRoom()
	
	Global.currentRoom = room
	
	saveDataRoom()
	
	if currentWorld != room.world:
		currentWorld = room.world
		
		var backgroundScene = LoadSystem.loadObject("{0}/background.tscn".format([room.world]), false)
		if background:
			background.queue_free()
		
		background = backgroundScene.instance()
		add_child(background)
	
	var currentRoomScene  = LoadSystem.loadObject(room.roomPath, false)
	currentRoom = currentRoomScene.instance()

	add_child(currentRoom)
	currentRoom.init(room.warpID, room.warpType)
	
	player.transition.call_deferred("transitionOut")
	player.resetParticles()

func saveDataRoom():
	if Global.currentRoom.world.get_base_dir() != "res://dimensions" and Global.currentRoom.category == "rooms":
		var worldIndex = Global.currentRoom.world.find_last("/")
		var worldPath = Global.savePath + "/worldRooms" + Global.currentRoom.world.substr(worldIndex)  + "/rooms"
		var _1 = Global._dir.make_dir_recursive(worldPath)
		if _1:
			print_debug("making {world} path gives the error: {error}".format(
				{"world" : Global.currentRoom.world.substr(worldIndex), "error" : _1})
			)
		
		var roomPath : String = worldPath + "/room{index}.tres".format({"index" : Global.currentRoom.ID})
		if Global.saveExist(roomPath):
			Global.currentRoom.data = Global.loadData(roomPath).data
		else:
			Global.saveData(roomPath, Global.currentRoom)
			
