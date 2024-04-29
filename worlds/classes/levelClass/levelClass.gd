class_name LevelClass extends Node2D

export var firstRoom := ""

signal changedRoom

var currentRoom
var currentRoomID := 0
var player


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
	
	currentRoom = currentRoomScene.instance()
	
	call_deferred("add_child", currentRoom)
	
	player.position = Global.save.player["position"]
	
	
	player.set_deferred("active", true)
	
	LoadSystem.closeLoad()


func loadRoom(room : String, warpID := 0, type := "warp"):
	
	player.active = false
	player.transition.transitionIn()
	
	emit_signal("changedRoom")
	
	if currentRoom:
		currentRoom.queue_free()
		
	currentRoom = load(room).instance()
	
	call_deferred("add_child", currentRoom)
	currentRoom.init(player, warpID, type)
	
	player.transition.call_deferred("transitionOut")
	player.set_deferred("active", true)
	player.resetParticles()



	
