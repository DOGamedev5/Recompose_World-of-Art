class_name LevelClass extends Node2D

export var canvasModulateColor := Color.white
onready var currentColor : Color
export var portalPath : NodePath
export(Array, NodePath) var doorWarps
export(Array, NodePath) var normalWarps
export(Array, NodePath) var tubeWarps
export(Array, NodePath) var portalWarps

onready var canvasModulate := CanvasModulate.new()

var isOnDimension := false
var clock := false
onready var timer := Timer.new()

onready var cameraLimitsMin := Vector2(-10000000, -10000000)
onready var cameraLimitsMax := Vector2(10000000, 10000000)
onready var playerNormalScene := preload("res://entities/player/powerStates/normal/playerNormal.tscn")

func _ready():
	Network.connect("memberLeft", self, "_memberLeft")
	Global.save = SaveGame.new() if not Global.save else Global.save
	
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
	
	setup()
	
func setup():
#	if not Global.packedPlayer:
#		Global.player = load(Global.save.player["player"]).instance()
#	else:
#		Global.player = Global.packedPlayer.instance()
	
	var portal : Node2D = get_node(portalPath)
	

	for member in Network.lobbyMembers:
		var player : PlayerBase = playerNormalScene.instance()
		if Network.steamID == member["ID"]:
			Global.player = player
		
		player.OwnerID = member["ID"]
		add_child(player)
		player.owner = self
		
		Players.playerList[member["ID"]].reference = player
		player.global_position = portal.global_position
	
#	AudioManager.playMusic("paintCaverns")
func _process(delta):
	if canvasModulate.color != currentColor and canvasModulate.visible:

		canvasModulate.color = lerp(canvasModulate.color, currentColor, 1.3*delta)
		Global.tree.call_group("canvasChanger", "set_color", canvasModulate.color)


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

func _exit_tree():
	if not Global.in_game:
		Global.save = null
		Global.savePath = ""
		Global.worldData.clear()
		Global.worldDataSetup = false
