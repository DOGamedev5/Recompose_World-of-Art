class_name RoomClass extends Node2D

export(Array, NodePath) var warp = []
export(Array, NodePath) var doors = []
export(Array, NodePath) var tubes = []
export(NodePath) var blocksPath
var blocks

export var limitsMin := Vector2(-10000000, -10000000)
export var limitsMax := Vector2(10000000, 10000000)
export(Color) var canvasModulateColor = Color(1, 1, 1, 1)

onready var canvasModulate = $"../CanvasModulate"

func _init():
	var tilemap : TileMap = TileMap.new()
	add_child(tilemap)
	tilemap.owner = self
	tilemap.scale = Vector2(2, 2)
	tilemap.cell_size = Vector2(8, 8)

func _ready():
	call_deferred("_simplesLightToggled", Global.options.simpleLight)
	blocks = get_node_or_null(blocksPath)
	
	if blocks:
		for n in Global.currentRoom.data["destroiedBlocks"]:
			var block = blocks.get_node_or_null(n)
			if block: block.queue_free()
	
	var _2 = Global.connect("simpleLightChanged", self, "_simplesLightToggled")
	
	get_parent().setCameraLimits(limitsMin, limitsMax)
	
func _simplesLightToggled(value): 
	canvasModulate.visible = value
	if canvasModulate.visible:
		canvasModulate.set_color(canvasModulateColor)

func init(warpID, type := "warp"):
	var path : NodePath
	
	if type == "warp":
		path = warp[warpID]
	elif type == "door":
		path = doors[warpID]
	else:
		path = tubes[warpID]
	
	
	get_node(path).init()
