class_name LevelClass extends Node2D

export var canvasModulateColor := Color.white
onready var currentColor : Color
export var portalPath : NodePath
onready var portal : RoomWarp

export(Array, NodePath) var doorWarps
export(Array, NodePath) var normalWarps
export(Array, NodePath) var tubeWarps
export(Array, NodePath) var portalWarps

onready var canvasModulate := CanvasModulate.new()
onready var timerModulate := CanvasModulate.new()

var isPortalSetup := false
var clock := false
onready var timer := Timer.new()

onready var cameraLimitsMin := Vector2(-10000000, -10000000)
onready var cameraLimitsMax := Vector2(10000000, 10000000)
#onready var playerNormalScene := preload("res://entities/player/powerStates/normal/playerNormal.tscn")

onready var objects : Node2D

signal clockInitialized

func _init():
	objects = Node2D.new()
	objects.name = "objects"
	add_child(objects)

func _ready():
	Network.connect("memberLeft", self, "_memberLeft")
	Global.save = SaveGame.new() if not Global.save else Global.save
	portal = get_node(portalPath)
	
#	Global.save.played = true
	Global.in_game = true
	Global.world = self
	timer.one_shot = true
	add_child(timer)
	
	canvasModulate.add_to_group("color")
	add_child(canvasModulate)
	canvasModulate.color = canvasModulateColor
	canvasModulate.visible = Global.options.colorEffect
	setCanvasModulate()
	
	Global.tree.call_group("canvasChanger", "set_color", currentColor)
	
	timerModulate.name = "timerModulate"
	add_child(timerModulate)
	
	setup()
	
func setup():

	if portal.has_method("createPlayers"):
		portal.createPlayers()
	else:
		isPortalSetup = true
		
		for member in Network.lobbyMembers:
			var player : PlayerBase = LoadedObjects.loaded["res://entities/player/powerStates/normal/playerNormal.tscn"].instance()
			if Network.steamID == member["ID"]:
				Global.player = player
			
			player.OwnerID = member["ID"]
			player.global_position = portal.global_position
			add_child(player)
			player.owner = self
			
			Players.playerList[member["ID"]].reference = player
	
#	AudioManager.playMusic("paintCaverns")
func _process(delta):
	var finalColor := currentColor
	if canvasModulate.color != currentColor and canvasModulate.visible:
		if clock: 
			if timer.time_left < 30:
				finalColor *= Color(0.97, 0.67, 0.78)
			elif timer.time_left < 60:
				finalColor *= Color(0.8, 0.75, 0.9)
			else:
				finalColor *= Color(0.6, 0.8, 0.95)
		
		canvasModulate.color = lerp(canvasModulate.color, finalColor, 1.3*delta)
		Global.tree.call_group("canvasChanger", "set_color", canvasModulate.color)
	else:
		if clock:
			if timer.time_left < 30:
				finalColor = Color(0.97, 0.67, 0.78)
			elif timer.time_left < 60:
				finalColor = Color(0.8, 0.75, 0.9)
			else:
				finalColor = Color(0.6, 0.8, 0.95)
				
		timerModulate.color = lerp(timerModulate.color, finalColor, 1.3*delta)
		Global.tree.call_group("canvasChanger", "set_color", timerModulate.color)

func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "player", "setCameraLimits", limitsMin, limitsMax)
	cameraLimitsMin = limitsMin
	cameraLimitsMax = limitsMax

func setCanvasModulate(color : Color = canvasModulateColor):
	currentColor = color

func _memberLeft(id):
	Players.playerList[id].reference.queue_free()
	Players.playerList.remove(id)

func loadSave():
#	Global.player.active = false
	
	position = Global.save.worldPosition
	Global.player.position = Global.save.player["position"]
#	Global.player.set_deferred("active", true)
	
	LoadSystem.closeLoad()

func setupTimer(time):
	clock = true
	timer.wait_time = time
	timer.start()
	portal.escapeActivate()
	
	emit_signal("clockInitialized")
	
	

func _exit_tree():
	if not Global.in_game:
		Global.save = null
		Global.savePath = ""
		Global.worldData.clear()
		Global.worldDataSetup = false
