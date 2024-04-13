class_name LevelClass extends Node2D

export var firstRoom := ""

var currentRoom
var currentRoomID := 0
var player


func _ready():
	AudioManager.playMusic("temple in ruins")

	player = load("res://entities/player/powerStates/normal/playerNormal.tscn").instance()
	add_child(player)
	
	call_deferred("loadSave")
	
	
func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "player", "setCameraLimits", limitsMin, limitsMax)

func loadSave():
	var room = "res://worlds/{0}/rooms/room{1}.tscn".format([
		Global.save.world["currentWorld"],
		Global.save.world["currentRoomID"]
	])
	
	player.active = false
	
	currentRoom = load(room).instance()
	call_deferred("add_child", currentRoom)
	
	player.position.x = Global.save.player["position"]["x"]
	player.position.y = Global.save.player["position"]["y"]
	
	player.set_deferred("active", true)

func loadRoom(room : String, warpID := 0):
	
	player.active = false
	player.transition.transitionIn()
	
	if currentRoom:
		currentRoom.queue_free()
	currentRoom = load(room).instance()
	
	call_deferred("add_child", currentRoom)
	currentRoom.init(player, warpID)
	
	player.transition.call_deferred("transitionOut")
	player.set_deferred("active", true)
	player.resetParticles()

	
