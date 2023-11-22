class_name RoomClass extends Node2D

export var warp = []

signal changeRoom(room, warpID)

func _ready():
	connect("changeRoom", get_parent(), "loadRoom")

func init(player, warpID):
	get_node(warp[warpID]).init(player)
