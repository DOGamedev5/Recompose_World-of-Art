class_name LevelClass extends Node2D

export(String, FILE, "*.tscn") var firstRoom := ""

signal changedRoom

var currentRoom
var currentRoomID := 0
var player

var currentWorld := "sandDesert"

var background

func _ready():
	
	var playerScene = LoadSystem.loadObject("res://entities/player/powerStates/normal/playerNormal.tscn")
	
	player = playerScene.instance()
	add_child(player)
	
	call_deferred("loadSave")
	
	AudioManager.playMusic("paintCaverns")
	
	
func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "player", "setCameraLimits", limitsMin, limitsMax)

func loadSave():
	var room : String
	
	
	room = Global.currentRoom.roomPath
	
	player.active = false
	
	var currentRoomScene = LoadSystem.loadObject(room)
	
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
	
	Global.currentRoom = room
	
	if currentWorld != room.world:
		
		currentWorld = room.world
		
		var backgroundScene = LoadSystem.loadObject("{0}/background.tscn".format([room.world]), false)
		
		if background:
			background.queue_free()
		
		background = backgroundScene.instance()
		add_child(background)
	
	
	var currentRoomScene  = LoadSystem.loadObject(room.roomPath, false)
	currentRoom = currentRoomScene.instance()

	call_deferred("add_child", currentRoom)
	currentRoom.init(player, room.warpID, room.warpType)
	
	player.transition.call_deferred("transitionOut")
	player.resetParticles()
