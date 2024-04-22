class_name Door extends Node2D

export(String, FILE, "*.tscn") var roomPath
export(String) var world = "paintWorld"
export(int) var roomID
export(String, "rooms", "especialRooms") var category = "rooms"

export var doorID := 0

onready var parent = get_parent()

func _ready():
	if not parent is RoomClass:
		parent = parent.get_parent()
	
	if roomID != 0:
		roomPath = "res://worlds/{world}/{category}/room{room}.tscn".format({
			"world" : world,
			"category" : category,
			"room" : roomID
		})

func init(player):
	player.global_position = position

func changeRoom(_player):
	get_parent().get_parent().loadRoom(roomPath, doorID, "door")
		
