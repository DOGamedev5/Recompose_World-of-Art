class_name LevelClass extends Node2D

export var canvasModulateColor := Color.white
onready var currentColor : Color
export(Array, NodePath) var doorWarps
export(Array, NodePath) var normalWarps
export(Array, NodePath) var tubeWarps
export(Array, NodePath) var portalWarps

onready var canvasModulate := CanvasModulate.new()

var isOnDimension := false
var clock := false
onready var timer := Timer.new()
var player

onready var cameraLimitsMin := Vector2(-10000000, -10000000)
onready var cameraLimitsMax := Vector2(10000000, 10000000)

func _ready():
	
#	Discord.set_presence({
#			status = "playing", 
#			afk = false,
#
#			activity = {
#				type = "game", 
#				name = "RECOMPOSE World of Art",
#				url = "http://localhost" ,
#				created_at = 0, 
#			}
#		})
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
	get_tree().call_group("canvasChanger", "set_color", currentColor)
	
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
