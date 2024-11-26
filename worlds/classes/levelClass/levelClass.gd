class_name LevelClass extends Node2D

export(String, FILE, "*.tscn") var firstRoom := ""

signal changedRoom

var currentRoom : RoomClass
var currentRoomID := 0
var player

var currentWorld := "sandDesert"

var isOnDimension := false
var clock := false
onready var timer := Timer.new()

var background

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
		Global.saveDataRoom(Global.currentRoom)
	
	room = Global.loadDataRoom(room)
	
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
	
	isOnDimension = room.world.get_base_dir() == "res://dimensions"
	
	add_child(currentRoom)

func loadSave():
	Global.player.active = false
	
	setupRoom(Global.currentRoom)
	
	Global.player.position = Global.save.player["position"]
	Global.player.set_deferred("active", true)
	
	LoadSystem.closeLoad()


func loadRoom(room):
	Global.player.transition.transitionIn()
	
	yield(Global.player.transition, "transitionedIn")
	emit_signal("changedRoom")
	
	setupRoom(room)

	currentRoom.init(room.warpID, room.warpType)

	Global.player.transition.call_deferred("transitionOut")
	Global.player.resetParticles()

func setupTimer(time):
	clock = true
	timer.wait_time = time
	timer.start()
