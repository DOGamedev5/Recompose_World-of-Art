class_name LevelClass extends Node2D

export var firstRoom := ""

var currentRoom
var player

signal changeRoom(room, warpID)

func _ready():
	AudioManager.playMusic("temple in ruins")
	connect("changeRoom", self, "loadRoom")
	player = load("res://entities/player/powerStates/normal/playerNormal.tscn").instance()
	add_child(player)
	call_deferred("loadRoom",firstRoom)
	
func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "player", "setCameraLimits", limitsMin, limitsMax)

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

	
