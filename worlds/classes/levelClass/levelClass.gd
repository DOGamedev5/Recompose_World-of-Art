class_name LevelClass extends Node2D

export(String, FILE, "*.tscn") var firstRoom := ""

signal changedRoom

var currentRoom : RoomClass
var currentRoomID := 0
var player

var currentWorld := "sandDesert"

var background

func _ready():
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
	
	saveDataRoom(Global.currentRoom.duplicate())
	
	Global.currentRoom = loadDataRoom(room).duplicate()
	
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

func loadSave():
	Global.player.active = false
	
	setupRoom(Global.currentRoom)
	
	Global.player.position = Global.save.player["position"]
	Global.player.set_deferred("active", true)
	
	LoadSystem.closeLoad()


func loadRoom(room : RoomData):
	Global.player.transition.transitionIn()
	
	yield(Global.player.transition, "transitionedIn")
	emit_signal("changedRoom")
	
	setupRoom(room)
	
	currentRoom.init(room.warpID, room.warpType)
	
	Global.player.transition.call_deferred("transitionOut")
	Global.player.resetParticles()

func saveDataRoom(room):
	verifyDirs(room)

	if room.world.get_base_dir() == "res://dimensions":
		Global.dimensionsRooms[room.ID] = room
		
		return
		
	var savePath : String= "worldRooms/"+ room.world.substr(13) + "/rooms/"

	Global.roomsToSave[savePath + "room{0}.tres".format([room.ID])] = room

func loadDataRoom(room : RoomData):
	
	verifyDirs(room)
	
	if room.world.get_base_dir() == "res://dimensions":
		if Global.dimensionsRooms.has(room.ID):
			room = Global.dimensionsRooms[room.ID]
		else:
			print(room.data)
		
		return room
	
	if Global.roomsToSave.has(room.savePath):
		room.data = Global.roomsToSave[room.savePath].data
	elif Global.saveExist(room.savePath):
		room.data = Global.loadData(room.savePath).data
	
	return room
	

func verifyDirs(room):
	var dir := Directory.new()
	if dir.open(Global.savePath) != OK:
		return
	
	for item in ["worldRooms", Global.currentRoom.world.substr(13), "rooms"]:
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
