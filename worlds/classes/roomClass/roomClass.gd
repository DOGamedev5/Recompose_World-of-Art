class_name RoomClass extends Node2D

export(Array, NodePath) var warp = []

export var limitsMin := Vector2(-10000000, -10000000)
export var limitsMax := Vector2(10000000, 10000000)
export(Color) var canvasModulateColor = Color(1, 1, 1, 1)

signal changeRoom(room, warpID)

onready var canvasModulate = $"../CanvasModulate"

func _ready():
	call_deferred("_simplesLightToggled", Global.simpleLight)
	
	var _1 = connect("changeRoom", get_parent(), "loadRoom")
	var _2 = Global.connect("simpleLightChanged", self, "_simplesLightToggled")
	
	get_parent().setCameraLimits(limitsMin, limitsMax)
	
func _simplesLightToggled(value):
	canvasModulate.visible = !value
	if canvasModulate.visible:
		canvasModulate.set_color(canvasModulateColor)
		print(canvasModulateColor)


func init(player, warpID):
	get_node(warp[warpID]).init(player)
