tool

class_name Door extends Node2D

export(String, FILE, "*.tscn") var roomPath
export(String) var world = "paintWorld"
export(int) var roomID
export(String, "rooms", "especialRooms") var category = "rooms"

export(int, 0, 1) var frame := 0 setget doorFrame

export var doorID := 0

onready var parent = get_parent()

var roomData : Dictionary

func _ready():
	if not parent is RoomClass:
		parent = parent.get_parent()
	
	if roomID != 0:
		roomPath = "res://worlds/{world}/{category}/room{room}.tscn".format({
			"world" : world,
			"category" : category,
			"room" : roomID
		})
	
	
	roomData = {
		roomPath = roomPath,
		world = world,
		category = category,
		ID = roomID
	}

func doorFrame(value):
	frame = value
	$CaveDoor.frame = value

func init(player):
	player.global_position = position

func changeRoom(_player):
	get_parent().get_parent().loadRoom(roomData, doorID, "door")
		
