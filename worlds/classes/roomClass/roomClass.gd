class_name RoomClass extends Node2D

export var warp = []

export var limitsMin := Vector2(-10000000, -10000000)
export var limitsMax := Vector2(10000000, 10000000)

signal changeRoom(room, warpID)

func _ready():
	connect("changeRoom", get_parent(), "loadRoom")
	get_parent().setCameraLimits(limitsMin, limitsMax)
	

func init(player, warpID):
	get_node(warp[warpID]).init(player)
