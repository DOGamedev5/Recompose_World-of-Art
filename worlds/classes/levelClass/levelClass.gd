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
	
	if Global.save.world["currentRoomID"] != 0:
		room = "res://worlds/{0}/{1}/room{2}.tscn".format([
			Global.save.world["currentWorld"],
			Global.save.world["currentTypeRoom"],
			Global.save.world["currentRoomID"]
		])
	
	else:
		room = Global.save.world["currentRoomPath"]
	
	player.active = false
	
	var currentRoomScene = LoadSystem.loadObject(room)
	
	var backgroundScene = LoadSystem.loadObject("res://worlds/{0}/background.tscn".format([Global.save.world["currentWorld"]]))
	
	background = backgroundScene.instance()
	currentRoom = currentRoomScene.instance()
	
	add_child(background)
	call_deferred("add_child", currentRoom)
	
	player.position = Global.save.player["position"]
	
	
	player.set_deferred("active", true)
	
	LoadSystem.closeLoad()


func loadRoom(room : Dictionary, warpID := 0, type := "warp"):
	
	player.transition.transitionIn()
	
	yield(player.transition, "transitionedIn")
	
	emit_signal("changedRoom")
	
	if currentRoom:
		currentRoom.queue_free()
	
	if currentWorld != room.world:
		currentWorld = room.world
		var backgroundScene = LoadSystem.loadObject("res://worlds/{0}/background.tscn".format([currentWorld]), false)
		if background:
			background.queue_free()
		
		background = backgroundScene.instance()
		add_child(background)
	
	
	var currentRoomScene  = LoadSystem.loadObject(room.roomPath, false)
	currentRoom = currentRoomScene.instance()

	call_deferred("add_child", currentRoom)
	currentRoom.init(player, warpID, type)
	
	player.transition.call_deferred("transitionOut")
	player.resetParticles()
