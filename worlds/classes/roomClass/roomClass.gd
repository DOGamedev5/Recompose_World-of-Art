class_name RoomClass extends Node2D

export(Array, NodePath) var warp = []
export(Array, NodePath) var doors = []

export var limitsMin := Vector2(-10000000, -10000000)
export var limitsMax := Vector2(10000000, 10000000)
export(Color) var canvasModulateColor = Color(1, 1, 1, 1)

onready var canvasModulate = $"../CanvasModulate"

func _ready():
	call_deferred("_simplesLightToggled", Global.options.simpleLight)
	
	
	var _2 = Global.connect("simpleLightChanged", self, "_simplesLightToggled")
	
	get_parent().setCameraLimits(limitsMin, limitsMax)
	
func _simplesLightToggled(value):
	canvasModulate.visible = !value
	if canvasModulate.visible:
		canvasModulate.set_color(canvasModulateColor)


func init(player, warpID, type := "warp"):
	var path : NodePath
	
	if type == "warp":
		path = warp[warpID]
	else:
		path = doors[warpID]
	
	get_node(path).init(player)
