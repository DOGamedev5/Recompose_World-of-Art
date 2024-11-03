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
	
	removeItens(get_node_or_null("blocks"), "destroiedBlocks")
	removeItens(get_node_or_null("coins"), "collectedCoins")
	
	var _2 = Global.connect("simpleLightChanged", self, "_simplesLightToggled")
	
	get_parent().setCameraLimits(limitsMin, limitsMax)

func removeItens(manager, key):
	if manager:
		for n in Global.currentRoom.data[key] as Array:
			var obj = manager.get_node_or_null(n)
			if obj:
				obj.queue_free()
			else:
				Global.currentRoom.data.erase(n)

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
