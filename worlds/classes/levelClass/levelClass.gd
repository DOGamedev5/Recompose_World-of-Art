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

func loadSave():
	Global.player.active = false
	
	loadDataRoom()
	
	var currentRoomScene = LoadSystem.loadObject(Global.currentRoom.roomPath)
	
	var backgroundScene = LoadSystem.loadObject("{0}/background.tscn".format([Global.currentRoom.world]))
	
	background = backgroundScene.instance()
	currentRoom = currentRoomScene.instance()
	
	add_child(background)
	call_deferred("add_child", currentRoom)
	
	Global.player.position = Global.save.player["position"]
	
	Global.player.set_deferred("active", true)
	
	LoadSystem.closeLoad()


func loadRoom(room : RoomData):
	Global.player.transition.transitionIn()
	
	yield(Global.player.transition, "transitionedIn")
	emit_signal("changedRoom")
	
	if currentRoom:
		currentRoom.queue_free()
	
	saveDataRoom()
	
#	print(Global.currentRoom.data)
	Global.currentRoom = room
#	print(Global.currentRoom.data)
	
	loadDataRoom()
	
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
	
	Global.player.transition.call_deferred("transitionOut")
	Global.player.resetParticles()

func loadDataRoom():
	
	var dir := Directory.new()
	if dir.open(Global.savePath) != OK: return
	
	for item in ["worldRooms", Global.currentRoom.world.substr(13), "rooms"]:
		if Global.currentRoom.world.get_base_dir() == "res://dimensions":
			break
		
		if not dir.dir_exists(item):
			var ERROR := dir.make_dir(item)
			if ERROR:
				print_debug("making {world} path gives the error: {error}".format(
					{"world" : item, "error" : ERROR})
				)
				break
		
		dir.change_dir(item)
	
	if Global.currentRoom.world.get_base_dir() == "res://dimensions":
		print("a")
		if Global.dimensionsRooms.has(Global.currentRoom.ID):
			Global.currentRoom.data = Global.dimensionsRooms[Global.currentRoom.ID].data
		else:
			Global.dimensionsRooms[Global.currentRoom.ID] = Global.currentRoom
		
		return
	
	if Global.roomsToSave.has(Global.currentRoom.savePath):
		Global.currentRoom.data = Global.roomsToSave[Global.currentRoom.savePath].data
	elif Global.saveExist(Global.currentRoom.savePath):
		Global.currentRoom.data = Global.loadData(Global.currentRoom.savePath).data
		

func saveDataRoom():
	
	var dir := Directory.new()
	if dir.open(Global.savePath) != OK:
		print("a")
		return
	
	for item in ["worldRooms", Global.currentRoom.world.substr(13), "rooms"]:
		if Global.currentRoom.world.get_base_dir() == "res://dimensions":
			break
		
		if not dir.dir_exists(item):
			var ERROR := dir.make_dir(item)
			if ERROR:
				print_debug("making {world} path gives the error: {error}".format(
					{"world" : item, "error" : ERROR})
				)
				break
		
		dir.change_dir(item)
	
	if Global.currentRoom.world.get_base_dir() == "res://dimensions":
		if Global.dimensionsRooms.has(Global.currentRoom.ID):
			Global.dimensionsRooms[Global.currentRoom.ID].data = Global.currentRoom.data
		else:
			Global.dimensionsRooms[Global.currentRoom.ID] = Global.currentRoom
		
		return
		
	var savePath := dir.get_current_dir()
	
	if Global.roomsToSave.has(savePath + "room{0}.tres".format([Global.currentRoom.ID])):
		Global.roomsToSave[savePath + "room{0}.tres".format([Global.currentRoom.ID])].data = Global.currentRoom.data
	else:
		Global.roomsToSave[savePath + "room{0}.tres".format([Global.currentRoom.ID])] = Global.currentRoom

