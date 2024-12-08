class_name LevelClass extends Node2D

export var canvasModulateColor := Color.white
export(Array, NodePath) var doorWarps
export(Array, NodePath) var normalWarps
export(Array, NodePath) var tubeWarps
export(Array, NodePath) var portalWarps

onready var canvasModulate := CanvasModulate.new()

var isOnDimension := false
var clock := false
onready var timer := Timer.new()
var player

func _ready():
	Global.save = SaveGame.new() if not Global.save else Global.save
	Global.in_game = true
	timer.one_shot = true
	add_child(timer)
	
	add_child(canvasModulate)
	
	if not Global.worldDataSetup:
		Global.worldDataSetup = true
		loadSave()
	elif Global.waintingToChange:
		match Global.changingInfo.warpType:
			"warp":
				get_node(normalWarps[Global.changingInfo.warpID]).init()
			"tube":
				get_node(tubeWarps[Global.changingInfo.warpID]).init()
			"door":
				get_node(doorWarps[Global.changingInfo.warpID]).init()
			"portal":
				get_node(portalWarps[Global.changingInfo.warpID]).init()
	
#	AudioManager.playMusic("paintCaverns")

func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "player", "setCameraLimits", limitsMin, limitsMax)

func _simplesLightToggled(value): 
	canvasModulate.visible = value
	if canvasModulate.visible:
		canvasModulate.set_color(canvasModulateColor)

func setCanvasModulate(color : Color):
	canvasModulateColor = color
	if canvasModulate.visible:
		canvasModulate.set_color(canvasModulateColor)

func loadSave():
#	Global.player.active = false
	
	position = Global.save.worldPosition
	player.position = Global.save.player["position"]
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
